package Recollect::Reminder;
use Moose;
use Data::Dumper;
use DateTime;
use DateTime::Duration;
use Carp qw/croak/;
use Recollect::Subscription;
use namespace::clean -except => 'meta';

has 'id'              => (is => 'ro', isa => 'Str', required => 1);
has 'subscription_id' => (is => 'ro', isa => 'Str', required => 1);
has 'zone_id'         => (is => 'ro', isa => 'Int', required => 1);
has 'created_at'      => (is => 'ro', isa => 'Str', required => 1);
has 'last_notified'   => (is => 'ro', isa => 'Str', required => 1);
has 'delivery_offset' => (is => 'ro', isa => 'Str', required => 1);
has 'target'          => (is => 'ro', isa => 'Str', required => 1);

has 'zone'             => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'subscription'     => (is => 'ro', isa => 'Object', lazy_build => 1,
                           handles => [qw/delete_url short_delete_url/]);
has 'offset_duration'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'nice_name'        => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'zone_url'         => (is => 'ro', isa => 'Str', lazy_build => 1);
has 'creation_datetime' => (is => 'ro', isa => 'DateTime', lazy_build => 1);
has 'last_notify_datetime' => (is => 'ro', isa => 'DateTime', lazy_build => 1);

extends 'Recollect::Collection';
with 'Recollect::Roles::HasZone';

sub By_subscription {
    my $class = shift;
    my $sub_id = shift;
    return $class->By_field('subscription_id' => $sub_id, all => 1);
}

sub All_due {
    my $class = shift;
    my %opts  = @_;
    die "as_of is required!" unless $opts{as_of};

    my $next_pickup_sql = <<EOSQL;
        SELECT zone_id, min(day) AS next_pickup
          FROM pickups
         WHERE day > \$1::timestamptz - '1day'::interval
         GROUP BY zone_id
EOSQL
    if ($ENV{RECOLLECT_DEBUG}) {
        my $sth = $class->run_sql($next_pickup_sql, [$opts{as_of}]);
        warn Dumper $sth->fetchall_arrayref({});
    }

    my $sql = <<EOSQL;
SELECT r.id 
    FROM reminders r 
    JOIN subscriptions s ON (r.subscription_id = s.id)
    JOIN (
$next_pickup_sql
         ) AS p ON (r.zone_id = p.zone_id)
    WHERE s.active
      AND \$1::timestamptz >= (p.next_pickup - r.delivery_offset)
      AND (p.next_pickup - r.delivery_offset) > r.last_notified
EOSQL
    my $sth = $class->run_sql($sql, [$opts{as_of}]);
    return [
        map { $_->[0] } @{ $sth->fetchall_arrayref }
    ];
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

sub update_last_notified {
    my $self = shift;
    my $when = shift || 'now';

    my $sth = $self->dbh->prepare(
        "UPDATE reminders SET last_notified = ?::timestamptz WHERE id = ?");
    die "Could not prepare query: " .$sth->errstr if $sth->err;
    $sth->execute($when, $self->id);
    die "Could not execute query: " .$sth->errstr if $sth->err;
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
    return join('-', $self->zone->area->name, $self->zone->name, $self->id, $self->target, $self->delivery_offset);
}

sub Is_valid_target {
    my $class = shift;
    my $target = shift;
    return $target =~ m/^(?:email|twitter|webhook|sms|voice):/;
}

sub _build_offset_duration {
    my $self = shift;
    my ($h,$m) = split ':', $self->delivery_offset;
    return DateTime::Duration->new(
        hours => $h,
        minutes => $m,
    );
}


sub _build_creation_datetime {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->created_at );
}

sub _build_last_notified_datetime {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->last_notified );
}

__PACKAGE__->meta->make_immutable;
1;
