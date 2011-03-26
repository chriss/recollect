#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use Recollect::Zone;

t::Recollect->setup_env;

Set_now_time: {
    # Set the time to right before a day change
    $ENV{RECOLLECT_NOW} = DateTime->new(
        month => 1,
        day   => 11,
        year  => 2011,
    );
}

my $redzone = Recollect::Zone->By_name('vancouver-south-red');
Next_pickup: {
    my $np = $redzone->next_pickup->[0];
    is $np->ymd, '2011-01-17', 'next-pickup';
    is $np->flags, 'GR', 'date has correct flags';
}

Next_pickups: {
    my $np = $redzone->next_pickup(3);
    is $np->[0]->ymd, '2011-01-17', 'next-pickup';
    is $np->[0]->flags, 'GR', 'date has correct flags';
    is $np->[1]->ymd, '2011-01-24', 'next-pickup';
    is $np->[1]->flags, 'GRYC', 'date has correct flags';
    is $np->[2]->ymd, '2011-01-31', 'next-pickup';
    is $np->[2]->flags, 'GR', 'date has correct flags';
}

Next_dow_change: {
    my $np = $redzone->next_dow_change;
    is $np->{last}->string, '2011-04-18 GRYC', 'last pickup is correct';
    is $np->{next}->string, '2011-04-27 GR', 'next pickup is correct';
}

Geo: {
    my $zone = Recollect::Zone->By_latlng('49.2877347', '-123.04528540000001');
    is $zone->name, 'vancouver-north-purple', 'by latlng';
}


done_testing();
exit;

