package Recollect::Subscription;
use Moose;
use DateTime;
use Recollect::User;
use Recollect::Zone;
use URI::Encode qw/uri_encode/;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'         => (is => 'ro', isa => 'Str',  required => 1);
has 'user_id'    => (is => 'ro', isa => 'Int',  required => 1);
has 'created_at' => (is => 'ro', isa => 'Str',  required => 1);
has 'free'       => (is => 'ro', isa => 'Str');

has 'user'        => (is => 'ro', isa => 'Object',           lazy_build => 1);
has 'payment_url' => (is => 'ro', isa => 'Maybe[Str]',       lazy_build => 1);
has 'reminders'   => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);
has 'created_date' => (is => 'ro', isa => 'Object', lazy_build => 1);

around 'Create' => sub {
    my $orig = shift;
    my $class = shift;
    my %args = @_;

    my $email = delete $args{email};
    my $user = Recollect::User->By_email($email)
            || Recollect::User->Create(email => $email)
            || die "Could not find or create user with email '$email'\n";
    $args{user_id} = $user->id;

    my $reminders = delete $args{reminders};
    $args{free} = $class->Is_free($reminders);
    $args{id} = $class->_build_uuid;
    my $subscription = $orig->($class, %args);

    $subscription->add_reminders($reminders);
    return $subscription;
};

sub Is_free {
    my $class = shift;
    my $reminders = shift;

    for my $rem (@$reminders) {
        return 0 if $rem->{target} =~ m/^(voice|sms):/;
    }
    return 1;
}

sub add_reminders {
    my $self = shift;
    my $reminders = shift;

    for my $rem (@$reminders) {
        Recollect::Reminder->Create(
            subscription_id => $self->id,
            zone_id => $rem->{zone_id},
            target  => $rem->{target},
        );
    }
}

sub to_hash {
    my $self = shift;
    return {
        user => $self->user->to_hash,
        reminders => $self->reminders,
        map { $_ => $self->$_() }
            qw/id created_at free/,
    };
}

sub _build_user {
    my $self = shift;
    return Recollect::User->By_id($self->user_id);
}

sub _build_reminders {
    my $self = shift;
    return Recollect::Reminder->By_subscription($self->id);
}

sub _build_payment_url {
    my $self = shift;
    return if $self->free;
    my $host = $self->config->{payment_host} || 'https://recollect.recurly.com';
    my $plan = $self->config->{payment_plan} || 'recollect';
    my $email = uri_encode $self->user->email;
    return "$host/subscribe/$plan?email=$email";
}

__PACKAGE__->meta->make_immutable;
1;
