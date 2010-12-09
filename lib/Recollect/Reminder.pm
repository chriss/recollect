package Recollect::Reminder;
use Moose;
use WWW::Shorten::isgd;
use Data::UUID;
use Recollect::Config;
use Recollect::Paypal;
use Recollect::Twilio;
use DateTime;
use DateTime::Duration;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'            => (is => 'ro', isa => 'Str',  required => 1);
has 'user_id'       => (is => 'ro', isa => 'Int',  required => 1);
has 'zone_id'       => (is => 'ro', isa => 'Int',  required => 1);
has 'created_at'    => (is => 'ro', isa => 'Object',  required => 1);
has 'last_notified' => (is => 'ro', isa => 'Object',  required => 1);
has 'delivery_offset'=>(is => 'ro', isa => 'Object',  required => 1);
has 'target'        => (is => 'ro', isa => 'Str',  required => 1);
has 'active'        => (is => 'rw', isa => 'Bool', required => 1);
has 'confirmed'     => (is => 'rw', isa => 'Bool', required => 1);
has 'confirm_hash'  => (is => 'ro', isa => 'Str',  required => 1);

has 'user'             => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'zone'             => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'nice_name'        => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'nice_zone'        => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'confirm_url'      => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'delete_url'       => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'short_delete_url' => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'zone_url'         => (is => 'ro', isa => 'Str', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        user => $self->user->to_hash,
        zone => $self->zone->to_hash,
        map { $_ => $self->$_() }
            qw/id user_id zone_id created_at last_notified delivery_offset
            target active confirmed confirm_hash/
    };
}

sub email_target { shift->target =~ m/^email:(.+)/ and return $1}
sub twitter_target { shift->target =~ m/^twitter:(.+)/ and return $1}
sub voice_target { shift->target =~ m/^voice:(.+)/ and return $1}
sub sms_target { shift->target =~ m/^sms:(.+)/ and return $1}

sub confirm {
    my $self = shift;
    $self->confirmed(1);
    $self->update;

    if (my $number = $self->voice_target) {
        $self->twilio->voice_call($number, "/call/new-user-welcome",
            StatusCallback => '/call/new-user-status?reminder=' . $self->id,
        );
    }
    elsif ($number = $self->sms_target) {
        $self->twilio->send_sms($number, <<EOT);
VanTrash Reminder is confirmed. Call us at 778-785-1357 for our dial-in pickup service.
EOT
    }
}

sub is_expired {
    my $self = shift;
    return DateTime->today > $self->expiry_datetime;
}

sub _build_duration {
    my $self = shift;
    my $p = $self->payment_period;
    return DateTime::Duration->new("${p}s" => 1);
}

sub _build_nice_name {
    my $self = shift;
    return join('-', $self->zone, $self->email, $self->name)
        . " (" . $self->target . ")";
}

sub _build_nice_zone {
    my $self = shift;
    my $zone = $self->zone;
    $zone =~ s/(\w+)/ucfirst($1)/eg;
    return $zone;
}

sub _build_confirm_url {
    my $self = shift;
    return join '/', $self->zone_url, $self->confirm_hash, 'confirm';
}

sub _build_delete_url {
    my $self = shift;
    return join '/', $self->zone_url,  $self->id, 'delete';
}

sub _build_short_delete_url {
    my $self = shift;
    return makeashorterlink($self->delete_url);
}

sub _build_zone_url {
    my $self = shift;
    my $type = shift || 'id';
    return join '/', Recollect::Config->base_url, 'zones', $self->zone, 'reminders';
}

sub _build_expiry_datetime {
    my $self = shift;
    return DateTime->now + DateTime::Duration->new(years => 5) unless $self->expiry;
    return DateTime->from_epoch(epoch => $self->expiry);
}

sub _build_payment_url {
    my $self = shift;

    return Recollect::Paypal->set_up_subscription(
        period => $self->payment_period,
        custom => $self->id,
        coupon => $self->coupon,
    );
}

has 'twilio' => (
    is => 'ro', isa => 'Recollect::Twilio', lazy_build => 1
);
sub _build_twilio { Recollect::Twilio->new }

sub By_id   { }
sub By_hash { }
sub By_email {}

sub Add {
    my $self = shift;
    my $rem = shift;

    $rem->{id} = _build_uuid();
    $rem->{offset}        = -6 unless defined $rem->{offset};
    $rem->{confirmed}     = 0;
    $rem->{created_at}    = time;
    $rem->{last_notified} = time;
    $rem->{confirm_hash}  = _build_uuid();
    $rem->{expiry}        ||= 0; # no expiry
    if (my $pp = $rem->{payment_period}) {
        die "Invalid payment_period - must be 'month' or 'year'"
            unless $pp =~ m/^(?:year|month|day)$/;
    }

}

sub Is_valid_target {
    my $class = shift;
    my $target = shift;
    return $target =~ m/^(?:email|twitter|webhook|sms|voice):/;
}

sub _build_uuid { 
    my $namespace = shift;
    my $hash = shift;
    return Data::UUID->new->create_str;
}

__PACKAGE__->meta->make_immutable;
1;
