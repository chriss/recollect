package Recollect::Notifier;
use Moose;
use DateTime;
use Recollect::Twitter;
use Recollect::Twilio;
use Recollect::Reminder;
use Recollect::Util qw/now/;
use JSON qw/encode_json/;
use namespace::clean -except => 'meta';

has 'twitter' => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'twilio'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'now'     => (is => 'rw', isa => 'Object', default    => sub { now() });

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Email';

sub need_notification {
    my $self = shift;
    my %args = @_;
    my $debug = $args{debug} || $ENV{RECOLLECT_DEBUG};

    my $due = Recollect::Reminder->All_due(
        as_of => $self->now,
    );
    $self->log("Found " . @$due . " reminders due.");

    return $due;
}

sub notify {
    my $self = shift;
    my $rem_id = shift or die "reminder is undef!";

    my $rem = Recollect::Reminder->By_id($rem_id);
    if ($self->_send_notification($rem)) {
        $rem->update_last_notified($self->now);
    }
}


sub _send_notification {
    my $self   = shift;
    my $rem    = shift;
    my $pickup = $rem->zone->next_pickup->[0];

    my $target = $rem->target;
    unless ($target =~ m/^(\w+):(.+)/) {
        warn "Could not understand target: '$target' for " . $self->nice_name;
        return;
    }
    my ($type, $dest) = ($1, $2);
    my $method = "_send_notification_$type";
    unless ($self->can($method)) {
        die "No such target: $type for " . $rem->nice_name;
        return;
    }

    $self->log("SENDING $type notification to $dest");
    return $self->$method(
        reminder => $rem,
        pickup   => $pickup,
        target   => $dest,
    );
}

sub _send_notification_email {
    my $self = shift;
    my %args = @_;

    $self->send_email(
        to            => $args{target},
        subject       => 'It is garbage day',
        template      => 'notification.html',
        template_args => {
            reminder    => $args{reminder},
            garbage_day => $args{pickup},
        },
    );
    return 1;
}

sub _send_notification_twitter {
    my $self = shift;
    my %args = @_;
    my $msg = $self->short_and_sweet_message(%args);

    unless ($self->twitter->new_direct_message($args{target}, $msg)) {
        if (my $error = $self->twitter->get_error()) {
            use Data::Dumper;
            warn Dumper $error;
            if ($error->{error} =~ m/not following you/) {
                $self->send_email(
                    to            => $args{reminder}->email,
                    subject       => 'Twitter VanTrash reminder failed!',
                    template      => 'twitter-fail.html',
                    template_args => {
                        reminder    => $args{reminder},
                        garbage_day => $args{pickup},
                        target => $args{target},
                        twitter => $self->model->config->Value('twitter_username'),
                    },
                );
                $self->log("Send Twitter fail email for $args{target}");

                # Lets call this a success because we emailed the person, and 
                # we don't want to keep emailing them over and over.
                return 1;
            }
            warn "Error sending tweet: $error->{error}";
            return 0;
        }
    }
    return 1;
}

sub _send_notification_webhook {
    my $self = shift;
    my %args = @_;

    my $body = encode_json {
        reminder => $args{reminder}->to_hash,
        pickup => $args{pickup}->to_hash,
    };

    LWP::UserAgent->new->post($args{target}, payload => $body);
    return 1;
}

sub short_and_sweet_message {
    my $self = shift;
    my %args = @_;

    my $msg = "It's garbage day on " . $args{pickup}->datetime->day_name
            . " for " . $args{reminder}->zone->title;
    if ($args{pickup}->flags eq 'Y') {
        $msg .= " - yard trimmings & food scraps will be picked up";
    }
    else {
        $msg .= " - no yard trimming pickup today";
    }
}

sub _send_notification_sms {
    my $self = shift;
    my %args = @_;

    $self->twilio->send_sms($args{target}, $self->short_and_sweet_message(%args));
    return 1;
}

sub _send_notification_voice {
    my $self = shift;
    my %args = @_;

    my $url = '/call/notify/' . $args{reminder}->zone;
    $self->twilio->voice_call($args{target}, $url,
        StatusCallback => $url . "/status?id=" . $args{reminder}->id,
    );

    return 1;
}

sub _build_twitter { Recollect::Twitter->new }
sub _build_twilio { Recollect::Twilio->new }

__PACKAGE__->meta->make_immutable;
1;
