#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use Recollect::Area;

my $model = t::Recollect->model;
isa_ok $model, 'Recollect::Model';

# Create an area
my $areas = Recollect::Area->All;
is_deeply $areas, [];

my $r = Recollect::Area->Create(
    name   => 'Vancouver',
    centre => '49.26422,-123.138542',
);

$areas = Recollect::Area->All;
is scalar(@$areas), 1;
my $area = shift @$areas;
ok $area->id > 0, 'has an id';
is $area->name,   'Vancouver', 'has a name';
is $area->centre, '49.26422,-123.138542', 'has a centre';
is_deeply $area->zones, [], 'area has no zones initially';

# Now add a zone
$area->add_zone(
    name   => 'vancouver-north-blue',
    title  => 'Vancouver North Blue',
    colour => 'blue',
);

my $zones = $area->zones;
is scalar(@$zones), 1, 'area has one zone now';
my $zone = shift @$zones;
ok $zone->id > 0;
is $zone->name, 'vancouver-north-blue';
is $zone->title, 'Vancouver North Blue';
is $zone->colour, 'blue';
is $zone->area_id, $area->id, 'zone area_id matches';
is $zone->area->id, $area->id, 'zone has area constructor';
is_deeply $zone->pickups, [], 'zone has no pickups initially';

# Now try to add that zone again.
ok 0;

# Now add some pickup days to this zone
$zone->add_pickups(
    [
        { day => '2010-01-01', flags => ''  },
        { day => '2010-01-08', flags => 'Y' },
        { day => '2010-01-15', flags => ''  },
    ],
);
my $pickups = $zone->pickups;
is scalar(@$pickups), 3, 'zone has 3 pickups';
ok $pickups->[0]{id};
ok $pickups->[1]{id};
ok $pickups->[2]{id};
is $pickups->[0]{day}, '2010-01-01';
is $pickups->[1]{day}, '2010-01-08';
is $pickups->[2]{day}, '2010-01-15';
is $pickups->[0]{flags}, '';
is $pickups->[1]{flags}, 'Y';
is $pickups->[2]{flags}, '';

# Now try adding a duplicate pickup
# Can use a pg UNIQUE constraint?
eval { $zone->add_pickups( [ { day => '2010-01-01', flags => ''  } ] ) };
ok $@, "Failed to add a duplicate pickup ($@)";

done_testing();
exit;

