package Recollect::Zone;
use Moose;
use Recollect::Area;
use Recollect::Pickup;
use Scalar::Util qw/weaken/;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';
with 'Recollect::Roles::Cacheable';

has 'id'      => (is => 'ro', isa => 'Int',              required   => 1);
has 'name'    => (is => 'ro', isa => 'Str',              required   => 1);
has 'title'   => (is => 'ro', isa => 'Str',              required   => 1);
has 'colour'  => (is => 'ro', isa => 'Str',              required   => 1);
has 'area_id' => (is => 'ro', isa => 'Int',              required   => 1);
has 'area'    => (is => 'ro', isa => 'Object',           lazy_build => 1);
has 'pickups' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);
has 'uri'     => (is => 'ro', isa => 'Str',              lazy_build => 1);

sub By_area_id {
    my $class = shift;
    my $area_id = shift;
    my $sth = $class->By_field(area_id => $area_id, args => [ ['name ASC'] ],
        handle_pls => 1);
    my @zones;
    while (my $row = $sth->fetchrow_hashref) {
        push @zones, $class->new($row);
    }
    return \@zones;
}

my $valid_point = qr/^-?\d+\.\d+$/;
sub By_latlng {
    my $class = shift;
    my ($lat, $lng) = @_;
    return unless $lat =~ $valid_point and $lng =~ $valid_point;
    
    my $sth = $class->run_sql(
        'SELECT id FROM zones WHERE ST_Contains(geom, ?) LIMIT 1',
        [ "POINT($lat $lng)" ],
    );
    return undef unless $sth->rows == 1;
    return $class->By_id($sth->fetchrow_arrayref->[0]);
}

sub next_pickup {
    my $self = shift;
    my $limit = shift || 1;

    my $pickups = Recollect::Pickup->By_zone_id(
        $self->id,
        args  => [ 'day ASC', $limit ],
        where => [ 'day' => { '>', $self->_now } ],
    );

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
    
    my $pickups = Recollect::Pickup->By_zone_id(
        $self->id,
        where => [ 'day', => { '>', $self->_now } ],
    );
    for my $p (@$pickups) {
        if ($p->day_of_week != $last_dow) {
            return {
                last => $last_pickup,
                next => $p,
            };
        }
        $last_pickup = $p;
    }

    die "Could not find the next dow change for zone " . $self->name;
}


sub to_hash {
    my $self = shift;
    my %opts = @_;

    my $hash = {
        area => $self->area->to_hash,
        map { $_ => $self->$_() } qw/id name title colour/
    };

    if ($opts{verbose}) {
        $hash->{pickupdays} = [ map { $_->to_hash } @{ $self->pickups } ];
        $hash->{nextpickup} = $self->next_pickup->[0]->to_hash;
    }

    return $hash;
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

sub _build_uri {
    my $self = shift;
    return "/api/areas/" . $self->area_id . "/zones/" . $self->name;
}

__PACKAGE__->meta->make_immutable;
1;
