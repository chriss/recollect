package Recollect::Subscription;
use Moose;
use DateTime;
use Recollect::User;
use Recollect::Zone;
use Recollect::Util;
use Recollect::Reminder;
use URI::Encode qw/uri_encode/;
use List::MoreUtils qw/any/;
use DateTime::Format::Pg;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Recurly';
with 'Recollect::Roles::Template';
with 'Recollect::Roles::Email';

has 'id'         => (is => 'ro', isa => 'Str',  required => 1);
has 'user_id'    => (is => 'ro', isa => 'Int',  required => 1);
has 'created_at' => (is => 'ro', isa => 'Str',  required => 1);
has 'free'       => (is => 'ro', isa => 'Str',  required => 1);
has 'active'     => (is => 'ro', isa => 'Bool', required => 1);

has 'user'        => (is => 'ro', isa => 'Object',           lazy_build => 1);
has 'url'         => (is => 'ro', isa => 'Str',              lazy_build => 1);
has 'payment_url' => (is => 'ro', isa => 'Maybe[Str]',       lazy_build => 1);
has 'reminders'   => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);
has 'created_date' => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'delete_url'   => (is => 'ro', isa => 'Str', lazy_build => 1);

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
    $args{active} = $args{free} = $class->Is_free($reminders);
    $args{id} = $class->_build_uuid;
    my $subscription = $orig->($class, %args);

    if ($args{free}) {
        $subscription->recurly->create_account(
            account_code => $args{id},
            email => $email,
            username => $email,
        );
    }

    $subscription->add_reminders($reminders);
    $subscription->log("New subscription created for user $email");

    $subscription->send_confirmation_email if $args{free};
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

sub mark_as_active   { shift->_set_active_flag(1) }
sub mark_as_inactive { shift->_set_active_flag(0) }

sub _set_active_flag {
    my $self = shift;
    my $value = shift;
    my $dbh = $self->dbh;

    my $sth = $self->dbh->prepare(
        "UPDATE subscriptions SET active = ?  WHERE id = ?"
    );
    $sth->execute($value, $self->id);
    $self->{active} = $value;
    $self->log("Subscription " . $self->id . " is now "
        . ($value ? '' : 'in') . 'active');
    $self->send_confirmation_email if $value;
}

sub send_confirmation_email {
    my $self = shift;

    $self->send_email(
        template => 'signup-success.html',
        template_args => {
            subscription => $self,
            twitter => $self->config->{twitter_username},
        },
        from => 'Recollect <feedback@recollect.net>',
        to => $self->user->email,
        subject => 'Welcome to the Recollect Reminder Service',
    );
}

sub add_reminders {
    my $self = shift;
    my $reminders = shift;

    for my $rem (@$reminders) {
        Recollect::Reminder->Create(
            subscription_id => $self->id,
            zone_id => $rem->{zone_id},
            target  => $rem->{target},
            delivery_offset => $rem->{delivery_offset},
        );
    }
}

sub to_hash {
    my $self = shift;
    return {
        user => $self->user->to_hash,
        reminders => [ map { $_->to_hash } @{$self->reminders} ],
        map { $_ => $self->$_() }
            qw/id created_at free active/,
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
    my $host = $self->payment_host;
    my $plan_name = lc $self->reminders->[0]->zone->area->name;
    my $email = uri_encode $self->user->email;
    return
          "$host/subscribe/$plan_name/"
        . $self->id . "/"
        . $self->user->email
        . "?email=$email";
}

sub _build_url {
    my $self = shift;
    return '/api/subscriptions/' . $self->id;
}

sub _build_delete_url {
    my $self = shift;
    return $self->config->{base_url} . '/subscription/delete/' . $self->id;
}

sub twitter_target {
    return any { $_->twitter_target } @{ shift->reminders }
}

sub _build_created_date {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->created_at );
}

around 'delete' => sub {
    my $orig = shift;
    my $self = shift;

    eval { $self->recurly->delete_account($self->id) };
    warn "Error when deleting account " . $self->id . ": $@\n";
    $orig->($self, @_);
};

__PACKAGE__->meta->make_immutable;
1;
