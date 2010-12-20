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

sub By_area_id {
    my $class = shift;
    my $area_id = shift;
    my $sth = $class->By_field(area_id => $area_id, args => [ ['name ASC'] ]);
    my @zones;
    while (my $row = $sth->fetchrow_hashref) {
        push @zones, $class->new($row);
    }
    return \@zones;
}

sub next_pickup {
    my $self = shift;
    my $limit = shift || 1;

    my $pickups = Recollect::Pickup->By_zone_id(
        $self->id,
        args  => [ 'day ASC', $limit ],
        where => [ 'day', => { '>', $self->_now } ],
    );

    return $pickups->[0] if $limit == 1;
    return $pickups;
}

sub last_pickup {
    my $self = shift;

    my $pickups = Recollect::Pickup->By_zone_id(
        $self->id,
        args  => [ 'day DESC', 1 ],
        where => [ 'day', => { '<', $self->_now } ],
    );
    return $pickups->[0];
}

sub next_dow_change {
    my $self = shift;

    my $last_pickup = $self->last_pickup;
    my $last_dow = $last_pickup->day_of_week;
    warn "last_pickpp: " . $last_pickup->ymd . ' dow: ' . $last_dow;
    
    my $pickups = Recollect::Pickup->By_zone_id(
        $self->id,
        where => [ 'day', => { '>', $self->_now } ],
    );
    for my $p (@$pickups) {
        next if $p->day_of_week == $last_dow;
        return $p;
    }

    die "Could not find the next dow change for zone " . $self->name;
}


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

sub _build_area {
    my $self = shift;
    return Recollect::Area->By_id($self->area_id);
}

sub _build_pickups {
    my $self = shift;
    my $pickups = eval { Recollect::Pickup->By_zone_id($self->id) } || [];
    return $pickups;
}

sub _now {
    if (my $now = $ENV{RECOLLECT_NOW}) {
        return join ' ', $now->ymd, $now->hms;
    }
    return 'now';
}

__PACKAGE__->meta->make_immutable;
1;
