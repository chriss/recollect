package Recollect::Pickup;
use Moose;
use DateTime::Functions;
use DateTime::Format::Pg;
use Carp qw/croak/;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'         => (is => 'ro', isa => 'Int',      required   => 1);
has 'zone_id'    => (is => 'ro', isa => 'Int',      required   => 1);
has 'day'        => (is => 'ro', isa => 'Str',      required   => 1);
has 'flags'      => (is => 'ro', isa => 'Str',      required   => 1);

has 'zone'       => (is => 'ro', isa => 'Object',   lazy_build => 1);
has 'string'     => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'pretty_day' => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'datetime'   => (is => 'ro', isa => 'DateTime', lazy_build => 1,
                     handles => ['ymd', 'day_of_week']);

sub By_zone {
    my $self = shift;
    my $zone = shift;
    my $obj_please = shift;
    die 'todo';
}

sub By_zone_id {
    my $class = shift;
    my $zone_id = shift;
    my %opts = @_;

    my $sth = $class->By_field(zone_id => $zone_id, %opts);
    my @pickups;
    while (my $row = $sth->fetchrow_hashref) {
        push @pickups, $class->new($row);
    }
    croak "Could not find any pickups for zone_id=$zone_id" unless @pickups;
    return \@pickups;
}

sub to_hash {
    my $self = shift;
    return {
        day => $self->ymd,
        zone_id => $self->zone_id,
        string => $self->string,
        flags => $self->flags,
    };
}

sub _build_zone {
    my $self = shift;
    die 'todo';
}

sub _build_string {
    my $self = shift;
    return join ' ', $self->ymd, ($self->flags ? $self->flags : ());
}

sub _build_pretty_day {
    my $self = shift;
    my $dt = $self->datetime;
    return $dt->day_name . ', ' . $dt->month_name . ' ' . $dt->day;
}

sub _build_datetime {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->day );
}

__PACKAGE__->meta->make_immutable;
1;
