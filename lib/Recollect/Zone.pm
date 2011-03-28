package Recollect::Zone;
use Moose;
use Recollect::Area;
use Recollect::Pickup;
use Recollect::PlaceInterest;
use Scalar::Util qw/weaken/;
use namespace::clean -except => 'meta';
use feature qw/switch/;

extends 'Recollect::Collection';
with 'Recollect::Roles::Cacheable';

has 'id'          => (is => 'ro', isa => 'Int', required => 1);
has 'name'        => (is => 'ro', isa => 'Str', required => 1);
has 'title'       => (is => 'ro', isa => 'Str', required => 1);
has 'colour_name' => (is => 'ro', isa => 'Str', required => 1);
has 'line_colour' => (is => 'ro', isa => 'Str', required => 1);
has 'poly_colour' => (is => 'ro', isa => 'Str', required => 1);
has 'area_id'     => (is => 'ro', isa => 'Int', required => 1);

has 'area'    => (is => 'ro', isa => 'Object',           lazy_build => 1);
has 'pickups' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);
has 'uri'     => (is => 'ro', isa => 'Str',              lazy_build => 1);
has 'style'   => (is => 'ro', isa => 'HashRef',          lazy_build => 1);
has 'polygons' => (is => 'ro', isa => 'ArrayRef[HashRef]', lazy_build => 1);
has 'rgb_color' => (is => 'ro', isa => 'Str',            lazy_build => 1);

# Load geometry only on demand
sub Columns {
    'id, name, title, colour_name, line_colour, poly_colour, area_id'
}

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
        'SELECT id FROM zones WHERE ST_Contains(geom, ?)',
        [ "POINT($lat $lng)" ],
    );
    given ($sth->rows) {
        when (0) {
            Recollect::PlaceInterest->Increment("$lat $lng");
            return;
        }
        when (1) {
            $class->log("Lookup - ($lat,$lng)");
        }
        default {
            $class->log("Error? Multiple zones found for point ($lat,$lng)");
        }
    }
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
    return {
        last => 0,
        next => 0,
    };
}


sub to_hash {
    my $self = shift;
    my %opts = @_;

    my $hash = {
        area => $self->area->to_hash,
        map { $_ => $self->$_() }
            qw/id name title colour_name line_colour poly_colour/
    };

    $hash->{pickupdays} = [ map { $_->to_hash } @{ $self->pickups } ];
    $hash->{nextpickup} = $self->next_pickup->[0]->to_hash;

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

sub delete_all_pickups {
    my $self = shift;
    $self->run_sql('DELETE FROM pickups WHERE zone_id = ?', [$self->id]);
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
    return $self->area->uri . "/zones/" . $self->name;
}

sub _build_style {
    my $self = shift;
    return {
        colour_name => $self->name . '-' . $self->colour_name,
        map { $_ => $self->$_ } qw/line_colour poly_colour/
    }
}

sub _build_polygons {
    my $self = shift;
    my $geom_text = $self->sql_singlevalue(
        'SELECT ST_AsText(geom) FROM zones WHERE id = ?',
        [ $self->id ]
    );
    return [] unless $geom_text;
    $geom_text =~ s/^MULTIPOLYGON\(\(//;
    $geom_text =~ s/\)\)$//;
    my @polygon_texts = split qr/\),\(/, $geom_text;
    my @polygons;
    for my $p (@polygon_texts) {
        $p =~ s/^\(//; $p =~ s/\)$//;
        my @points = split ',', $p;
        push @polygons, {
            name => $self->name,
            title => $self->title,
            colour_name => $self->colour_name,
            points => [
                map {
                    my ($lat, $lng) = split ' ', $_;
                    { lat => $lat, lng => $lng }
                    } @points
            ],
        };
        
    }
    return \@polygons;
}

sub _build_rgb_color {
    my $self = shift;
    # Poly & Line color is AABBGGRR, so we need to reverse it & drop the AA
    my $pcolor = $self->poly_colour;
    $pcolor =~ m/^(..)(..)(..)(..)$/;
    return "$3$2$1";

}

sub as_tron {
    my $self = shift;

    return {
        tron_version => 1,
        zones => [
            {
                name => $self->name,
                title => $self->title,
                color => $self->rgb_color,
                geography => [
                    map {
                        [ map { [ $_->{lat}, $_->{lng} ] } @{ $_->{points} } ]
                    }
                    @{ $self->polygons }
                ],
            }
        ],
        pickups => [
            map {
                {
                    date => $_->day,
                    zone => $self->name,
                    flags => $_->flags,
                }
            } @{ $self->pickups }
        ],
    };
}

sub set_geom_from_tron {
    my $self = shift;
    my $spec = shift;

    my $geom;
    my $coords = $spec->{coordinates};
    if ($spec->{type} eq 'Polygon') {
        my @points;
        for my $coord (@{ $coords->[0] }) {
            push @points, "$coord->[0] $coord->[1]";
        }
        $geom = "MULTIPOLYGON(((" . join(',', @points) . ")))";
    }
    else {
        my @polygons;
        for my $polygon (@{ $coords->[0] }) {
            my @points;
            for my $coord (@$polygon) {
                push @points, "$coord->[0] $coord->[1]";
            }
            push @polygons, "((" . join(',', @points) . "))";
        }
        $geom = "MULTIPOLYGON(" . join(',', @polygons) . ")";
    }

    $self->run_sql(
        'UPDATE zones SET geom = ST_GeomFromText(?) WHERE id = ?',
        [ $geom, $self->id ],
    );
}

__PACKAGE__->meta->make_immutable;
1;
