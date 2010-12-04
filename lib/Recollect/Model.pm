package Recollect::Model;
use Moose;
use Recollect::Email;
use Recollect::Schema;
use Recollect::Areas;
use Recollect::Pickups;
use Recollect::Zones;
use Recollect::Reminders;
use Recollect::Notifier;
use Recollect::Paypal;
use Recollect::KML;
use Recollect::Config;
use Carp qw/croak/;
use Data::ICal;
use Data::ICal::Entry::Event;
use Date::ICal;
use DateTime;
use Fatal qw/rename/;
use YAML qw/LoadFile DumpFile/;
use Data::Dumper;
use namespace::clean -except => 'meta';

has 'base_path' => (is => 'ro', isa => 'Str',    required   => 1);
has 'areas'     => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'zones'     => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'pickups'   => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'mailer'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'reminders' => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'schema'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'notifier'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'kml'       => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'config'    => (is => 'ro', isa => 'Object', lazy_build => 1);

sub days {
    my $self = shift;
    my $zone = shift;
    my $obj_please = shift;

    return $self->pickups->by_zone($zone, $obj_please);
}

sub ical {
    my $self = shift;
    my $zone = shift;
    my $days = $self->days($zone);

    my $ical = Data::ICal->new();
    for my $day (@$days) {
        my $evt = Data::ICal::Entry::Event->new;
        my $summary = 'Garbage pickup day';
        $summary .= ' & Yard trimmings day' if $day->{flags} eq 'Y';
        my $date = join('', map { $day->{$_} } qw(year month day));
        $evt->add_properties(
            summary => $summary,
            dtstart => $date,
        );
        $ical->add_entry($evt);
    }

    return $ical->as_string;
}

sub next_pickup {
    my $self = shift;
    my $zone = shift;
    my $limit = shift || 1;
    my $datetime = shift;
    my $obj_please = shift;

    my $days = $self->days($zone, $obj_please);
    die "Not a valid zone: '$zone'\n" unless @$days;
    my $tonight = $self->tonight;
    my @return;
    for my $d (@$days) {
        my $dh = $obj_please ? $d->to_hash : $d;
        my $dt = DateTime->new(
            (map { $_ => $dh->{$_} } qw/year month day/),
            time_zone => 'America/Vancouver',
        );
        next if $tonight > $dt;
        push @return, ($datetime ? $dt : $obj_please ? $d : $d->{string});
        last if @return == $limit;
    }
    return wantarray ? @return : @return == 1 ? $return[0] : \@return;
}

sub next_dow_change {
    my $self = shift;
    my $zone = shift;
    my $return_dt   = shift;

    my $days = $self->days($zone);
    die "Not a valid zone: '$zone'\n" unless @$days;
    my $tonight = $self->tonight;

    my $prev_dow;
    my $prev_day;
    for my $d (@$days) {
        my $dt = DateTime->new(
            (map { $_ => $d->{$_} } qw/year month day/),
            time_zone => 'America/Vancouver',
        );
        my $dow = $dt->day_of_week;
        if ($tonight < $dt and $prev_dow != $dow) {
            return (
                last => ($return_dt ? $prev_day : $prev_day->epoch),
                first => ($return_dt ? $dt : $dt->epoch),
            );
        }
        $prev_dow = $dow;
        $prev_day = $dt;
    }
    return;
}

sub Payment_required_for {
    my $class = shift;
    my $target = shift;
    return $target =~ m/^(?:voice|sms):/;
}

sub add_reminder {
    my $self = shift;
    my $rem  = shift or croak "A reminder is mandatory!";

    unless ($self->zones->by_name($rem->{zone})) {
        croak "Sorry, '$rem->{zone}' is not a valid zone!";
    }
    unless ($rem->{email}) {
        croak "You must enter an email address.";
    }

    my $next_pickup_dt = $self->next_pickup($rem->{zone}, 1, 'dt');
    $rem->{next_pickup} = $next_pickup_dt->epoch;

    my $payment_req = $self->Payment_required_for($rem->{target});
    if ($payment_req) {
        my $dt = DateTime->today + DateTime::Duration->new(weeks => 2);
        $rem->{expiry} = $dt->epoch;
    }

    my $robj = eval { $self->reminders->add($rem) };
    my $err = "Unknown error";
    if ($err = $@) {
        warn "Error inserting reminder ($err): " . Dumper($rem);

        # Perhaps the reminder exists already?
        if (my @rem = $self->reminders->by_email($rem->{email})) {
            for my $r (@rem) {
                next if $r->confirmed;
                warn "Duplicate reminder, but we found this unconfirmed reminder for $rem->{email}";
                $robj = $r;
                last;
            }
        }
    }
    die $err unless $robj;

    $self->send_reminder_confirm_email($robj) unless $payment_req;
    return $robj;
}

sub send_reminder_confirm_email {
    my $self = shift;
    my $robj = shift;
    my %opts = @_;

    $self->mailer->send_email(
        to => $robj->email,
        subject => 'Recollect Reminder Confirmation',
        template => 'reminder-confirm.html',
        template_args => {
            ($opts{message} ? (message => $opts{message}) : ()),
            zone => $robj->zone,
            confirm_url => $robj->confirm_url,
            delete_url => $robj->delete_url,
        },
    );
}

sub confirm_reminder {
    my $self = shift;
    my $rem = shift or croak 'A reminder is mandatory!';

    $self->mailer->send_email(
        to => $rem->email,
        subject => 'Your Recollect reminder is created',
        template => 'reminder-success.html',
        template_args => {
            reminder => $rem,
            twitter => $self->config->Value('twitter_username'),
        },
    );

    $rem->confirm;
}

sub delete_reminder {
    my $self = shift;
    my $id   = shift or croak 'An id is mandatory!';

    my $rem = $self->reminders->by_id($id);
    return unless $rem;

    if (my $profile_id = $rem->subscription_profile_id) {
        Recollect::Paypal->cancel_subscription($profile_id);
    }

    $rem->delete;
    return $rem;
}

sub _load_file {
    my $self = shift;
    my $name = $_[0] . 'file';
    my $file = $self->$name;
    return {} unless -e $file;
    my @stats = stat($file);
    $self->{_modified}{$file} = $stats[9];
    $self->{_size}{$file} = $stats[7];
    return LoadFile($file) || {};
}

sub _build_zonefile {
    my $self = shift;
    return $self->base_path . "/data/trash-zone-times.yaml";
}

sub _build_mailer {
    my $self = shift;
    return Recollect::Email->new( base_path => $self->base_path );
}

sub _build_reminders {
    my $self = shift;
    return Recollect::Reminders->new(
        schema => $self->schema,
    );
}

sub _build_schema {
    my $self = shift;
    my $db_file = $self->base_path . '/data/recollect.db';
    return Recollect::Schema->connect("dbi:SQLite:$db_file");
}

sub _build_notifier {
    my $self = shift;
    return Recollect::Notifier->new(
        reminders => $self->reminders,
        mailer    => $self->mailer,
        pickups   => $self->pickups,
        model     => $self,
    );
}

sub now {
    return $ENV{RECOLLECT_NOW} if $ENV{RECOLLECT_NOW};
    my $self = shift;
    my $dt = DateTime->now;
    $dt->set_time_zone('America/Vancouver');
    return $dt;
}

sub tonight {
    my $self = shift;
    my $now = $self->now;
    $now->set( hour => 23, minute => 59 );
}

sub _build_areas {
    my $self = shift;
    return Recollect::Areas->new( schema => $self->schema );
}

sub _build_zones {
    my $self = shift;
    return Recollect::Zones->new( schema => $self->schema );
}

sub _build_pickups {
    my $self = shift;
    return Recollect::Pickups->new( schema => $self->schema );
}

sub _build_kml {
    my $self = shift;
    my $base = $self->base_path;
    my $filename = -d "$base/root"
            ? "$base/root/zones.kml"
            : "$base/static/zones.kml";
    return Recollect::KML->new(filename => $filename);
}

sub _build_config { Recollect::Config->instance }

__PACKAGE__->meta->make_immutable;
1;
