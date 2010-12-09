package Recollect::Zone;
use Moose;
use Recollect::Area;
use Recollect::Pickup;
use Scalar::Util qw/weaken/;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'      => (is => 'ro', isa => 'Int',              required   => 1);
has 'name'    => (is => 'ro', isa => 'Str',              required   => 1);
has 'title'   => (is => 'ro', isa => 'Str',              required   => 1);
has 'colour'  => (is => 'ro', isa => 'Str',              required   => 1);
has 'area_id' => (is => 'ro', isa => 'Int',              required   => 1);
has 'area'    => (is => 'ro', isa => 'Object',           lazy_build => 1);
has 'pickups' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        area => $self->area->to_hash,
        map { $_ => $self->$_() } qw/id name title colour/
    };
}

sub uri {
    my $self = shift;
    return '/zones/' . $self->name;
}

sub add_pickups {
    my $self = shift;
    my $days = shift;

    for my $d (@$days) {
        Recollect::Pickup->Create( %$d, zone_id => $self->id );
    }
    delete $self->{pickups};
}

sub By_area_id {
    my $class = shift;
    my $area_id = shift;
    my $sth = $class->By_field(area_id => $area_id);
    my @zones;
    while (my $row = $sth->fetchrow_hashref) {
        push @zones, $class->new($row);
    }
    return \@zones;
}

sub _build_area {
    my $self = shift;
    return Recollect::Area->By_id($self->area_id);
}

sub _build_pickups {
    my $self = shift;
    return Recollect::Pickup->By_zone_id($self->id);
}

__PACKAGE__->meta->make_immutable;
1;
