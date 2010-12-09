package Recollect::Subscription;
use Moose;
use DateTime;
use Recollect::Paypal;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'         => (is => 'ro', isa => 'Int',  required => 1);
has 'user_id'    => (is => 'ro', isa => 'Int',  required => 1);
has 'created_at' => (is => 'ro', isa => 'Object',  required => 1);
has 'period'     => (is => 'ro', isa => 'Str',  required => 1);
has 'profile_id' => (is => 'ro', isa => 'Str');
has 'expiry'     => (is => 'ro', isa => 'Object',  required => 1);
has 'coupon'     => (is => 'ro', isa => 'Str',  default => '');

has 'user'        => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'zone'        => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'duration'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'payment_url' => (is => 'ro', isa => 'Str',    lazy_build => 1);
has 'reminders'   => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        user => $self->user->to_hash,
        reminders => $self->reminders,
        map { $_ => $self->$_() }
            qw/id created_at period profile_id expiry coupon/,
    };
}

sub _build_duration {
    my $self = shift;
    my $p = $self->period;
    return DateTime::Duration->new("${p}s" => 1);
}

sub _build_payment_url {
    my $self = shift;

    return Recollect::Paypal->set_up_subscription(
        period => $self->period,
        custom => $self->id,
        coupon => $self->coupon,
    );
}

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
