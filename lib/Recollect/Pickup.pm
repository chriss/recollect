package Recollect::Pickup;
use Moose;
use DateTime::Functions;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'         => (is => 'ro', isa => 'Int',      required   => 1);
has 'zone_id'    => (is => 'ro', isa => 'Int',      required   => 1);
has 'day'        => (is => 'ro', isa => 'Str',      required   => 1);
has 'flags'      => (is => 'ro', isa => 'Str',      required   => 1);

has 'zone'       => (is => 'ro', isa => 'Object',   lazy_build => 1);
has 'string'     => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'day_str'    => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'pretty_day' => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'datetime'   => (is => 'ro', isa => 'DateTime', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        day => $self->day->ymd,
        zone => $self->zone,
        string => $self->string,
        flags => $self->flags,
    };
}

sub By_zone_id {
    my $class = shift;
    my $zone_id = shift;
    my $sth = $class->By_field(zone_id => $zone_id);
    my @pickups;
    while (my $row = $sth->fetchrow_hashref) {
        push @pickups, $class->new($row);
    }
    return \@pickups;
}

sub _build_string {
    my $self = shift;
    return join ' ', $self->day, ($self->flags ? $self->flags : ());
}

sub _build_pretty_day {
    my $self = shift;
    my $dt = $self->datetime;
    return $dt->day_name . ', ' . $dt->month_name . ' ' . $dt->day;
}

sub By_zone {
    my $self = shift;
    my $zone = shift;
    my $obj_please = shift;
    return [];
}

sub by_epoch {
    my $self = shift;
    my $zone = shift;
    my $epoch  = shift;

    return undef;
}

__PACKAGE__->meta->make_immutable;
1;
