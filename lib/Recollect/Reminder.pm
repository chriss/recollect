package Recollect::Reminder;
use Moose;
use WWW::Shorten::isgd;
use Recollect::Config;
use Recollect::Paypal;
use Recollect::Twilio;
use DateTime;
use DateTime::Duration;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'              => (is => 'ro', isa => 'Str', required => 1);
has 'subscription_id' => (is => 'ro', isa => 'Str', required => 1);
has 'zone_id'         => (is => 'ro', isa => 'Int', required => 1);
has 'created_at'      => (is => 'ro', isa => 'Str', required => 1);
has 'last_notified'   => (is => 'ro', isa => 'Str', required => 1);
has 'delivery_offset' => (is => 'ro', isa => 'Str', required => 1);
has 'target'          => (is => 'ro', isa => 'Str', required => 1);

has 'zone'             => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'subscription',    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'nice_name'        => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'nice_zone'        => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'delete_url'       => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'short_delete_url' => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'zone_url'         => (is => 'ro', isa => 'Str', lazy_build => 1);

with 'Recollect::Roles::HasZone';

sub By_subscription {
    my $class = shift;
    my $sub_id = shift;
    return $class->By_field('subscription_id' => $sub_id, all => 1);
}

sub to_hash {
    my $self = shift;
    return {
        zone => $self->zone->to_hash,
        map { $_ => $self->$_() }
            qw/id subscription_id created_at last_notified delivery_offset
            target/
    };
}

sub email_target { shift->target =~ m/^email:(.+)/ and return $1}
sub twitter_target { shift->target =~ m/^twitter:(.+)/ and return $1}
sub voice_target { shift->target =~ m/^voice:(.+)/ and return $1}
sub sms_target { shift->target =~ m/^sms:(.+)/ and return $1}

sub _build_subscription {
    my $self = shift;
    return Recollect::Subscription->By_id($self->subscription_id);
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

sub _build_delete_url {
    my $self = shift;
    die 'todo';
}

sub _build_short_delete_url {
    my $self = shift;
    return makeashorterlink($self->delete_url);
}

sub Is_valid_target {
    my $class = shift;
    my $target = shift;
    return $target =~ m/^(?:email|twitter|webhook|sms|voice):/;
}

__PACKAGE__->meta->make_immutable;
1;
