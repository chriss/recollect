package Recollect::Model;
use Moose;
use Recollect::Email;
use Recollect::Pickup;
use Recollect::Zone;
use Recollect::Reminder;
use Recollect::Notifier;
use Recollect::Paypal;
use Recollect::KML;
use Carp qw/croak/;
use DateTime;
use Fatal qw/rename/;
use YAML qw/LoadFile DumpFile/;
use Data::Dumper;
use namespace::clean -except => 'meta';

with 'Recollect::Config';

has 'base_path' => (is => 'ro', isa => 'Str',    required   => 1);
has 'mailer'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'notifier'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'kml'       => (is => 'ro', isa => 'Object', lazy_build => 1);

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
            twitter => $self->config->{twitter_username},
        },
    );

    $rem->confirm;
}

sub _build_mailer {
    my $self = shift;
    return Recollect::Email->new( base_path => $self->base_path );
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

sub _build_kml {
    my $self = shift;
    my $base = $self->base_path;
    my $filename = -d "$base/root"
            ? "$base/root/zones.kml"
            : "$base/static/zones.kml";
    return Recollect::KML->new(filename => $filename);
}

__PACKAGE__->meta->make_immutable;
1;
