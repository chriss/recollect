package Recollect::User;
use Moose;
use DateTime::Format::Pg;
use Recollect::Reminder;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'           => (is => 'ro', isa => 'Str',        required   => 1);
has 'email'        => (is => 'ro', isa => 'Str',        required   => 1);
has 'created_at'   => (is => 'ro', isa => 'Str',        required   => 1);
has 'twittername'  => (is => 'ro', isa => 'Maybe[Str]', required   => 1);
has 'is_admin'     => (is => 'ro', isa => 'Bool',       required   => 1);
has 'created_date' => (is => 'ro', isa => 'Object',     lazy_build => 1);
has 'subscription_count' => (is => 'ro', isa => 'Num',  lazy_build => 1);
has 'reminders'    => (is => 'ro', isa => 'ArrayRef[Recollect::Reminder]',
                                                        lazy_build => 1);
has 'is_area_admin' => (is => 'ro', isa => 'Bool',      lazy_build => 1);
has 'area_admin'    => (is => 'ro', isa => 'Maybe[Object]', lazy_build => 1);

sub All_active {
    my $class = shift;
    my $sth = $class->run_sql(<<EOT, []);
SELECT DISTINCT(u.*) FROM users u
    JOIN subscriptions s ON (s.user_id = u.id)
    WHERE s.active = 't'
    ORDER BY created_at DESC
EOT
    return $class->_all_as_obj($sth);
}

sub _build_subscription_count { die "Not implemented yet" }

sub _build_reminders {
    my $self = shift;

    my $sth = $self->run_sql(<<EOT, [$self->id]);
SELECT r.* FROM reminders r
    JOIN subscriptions s ON (r.subscription_id = s.id)
    JOIN users u ON (s.user_id = u.id)
    WHERE u.id = ?
EOT
    return Recollect::Reminder->_all_as_obj($sth);
}

sub _build_created_date {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime($self->created_at);
}

sub By_email {
    my $class = shift;
    return $class->By_field('LOWER(email)' => lc shift);
}

sub By_twitter {
    my $class = shift;
    return $class->By_field('LOWER(twittername)' => lc shift);
}

sub to_hash {
    my $self = shift;
    return {
        email => $self->email,
        created_at => $self->created_at,
    };
}

sub _build_area_admin {
    my $self = shift;
    my $area_id = $self->sql_singlevalue(
        'SELECT area_id FROM area_admins WHERE user_id = ?', [$self->id],
    );
    return undef unless $area_id;
    return Recollect::Area->By_id($area_id);
}

sub _build_is_area_admin {
    my $self = shift;
    return $self->area_admin ? 1 : 0;
}

__PACKAGE__->meta->make_immutable;
1;
