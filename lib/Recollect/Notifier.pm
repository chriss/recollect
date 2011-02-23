package Recollect::Notifier;
use Moose;
use DateTime;
use Recollect::Reminder;
use Recollect::Util qw/now/;
use JSON qw/encode_json/;
use Carp qw/croak/;
use namespace::clean -except => 'meta';

has 'now'     => (is => 'rw', isa => 'Object', default    => sub { now() });

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Template';
with 'Recollect::Roles::Email';
with 'Recollect::Roles::Twilio';
with 'Recollect::Roles::Twitter';

sub need_notification {
    my $self = shift;
    my %args = @_;

    my $due = Recollect::Reminder->All_due(
        as_of => $self->now,
    );
    $self->log("Found " . @$due . " reminders due.");

    return $due;
}

sub notify {
    my $self = shift;
    my $rem_or_id = shift or croak "reminder or reminder_id is required";
    my $rem = ref($rem_or_id) ? $rem_or_id
                              : Recollect::Reminder->By_id($rem_or_id);
    die "Reminder ID: $rem_or_id is invalid!" unless $rem;
    if ($self->send_notification(reminder => $rem)) {
        $rem->update_last_notified($self->now);
    }
}


sub send_notification {
    my $self   = shift;
    my %opts   = @_;
    my $zone   = $opts{zone} || $opts{reminder}->zone;
    my $target = $opts{target} || $opts{reminder}->target;
    my $pickup = $zone->next_pickup->[0];

    unless ($target =~ m/^(\w+):(.+)/) {
        warn "Could not understand target: '$target' for " . $self->nice_name;
        return;
    }
    my ($type, $dest) = ($1, $2);
    my $method = "_send_notification_$type";
    unless ($self->can($method)) {
        die "No such target: $type for " . $opts{reminder}->nice_name;
        return;
    }

    $self->log("SENDING $type notification to $dest");
    return $self->$method(
        reminder => $opts{reminder},
        pickup   => $pickup,
        target   => $dest,
        zone     => $zone,
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
            if ($error->{error} =~ m/not following you/) {
                $self->send_email(
                    to            => $args{reminder}->subscription->user->email,
                    subject       => 'Recollect Twitter reminder failed!',
                    template      => 'twitter-fail.html',
                    template_args => {
                        reminder    => $args{reminder},
                        garbage_day => $args{pickup},
                        target => $args{target},
                        twitter => $self->config->{twitter_username},
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
            . " for " . $args{zone}->title;
    if ($args{pickup}->has_flag('Y')) {
        $msg .= " - yard trimmings & food scraps will be picked up";
    }
    else {
        $msg .= " - no yard trimming pickup today";
    }
    return $msg;
}

sub _send_notification_sms {
    my $self = shift;
    my %args = @_;

    $self->send_sms($args{target}, $self->short_and_sweet_message(%args));
    return 1;
}

sub _send_notification_voice {
    my $self = shift;
    my %args = @_;
    my $target = $args{target};

    my @args;
    if ($target =~ s/,([\w=]+)$//) {
        my $options = $1;
        if ($options =~ m/lang=(\w+)/) {
            push @args, "lang=$1";
        }
    }
    my $url = '/call/notify/' . $args{zone}->name;
    $url .= '?' . join '&', @args if @args;;

    $self->voice_call( $target, $url,
        ( $args{reminder}
            ? (StatusCallback => $url . "/status?id=" . $args{reminder}->id)
            : ()
        )
    );

    return 1;
}

__PACKAGE__->meta->make_immutable;
1;
