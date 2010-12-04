#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use DateTime;

$ENV{RECOLLECT_LOAD_DATA} = 1;
$ENV{RECOLLECT_NOW} = DateTime->new(year => 2009, month => 6, day => 1);

Sunny_day: {
    my $model = t::Recollect->model;
    my $zones = $model->zones->all('objects');
    is_deeply $model->reminders->all, [], 'is empty';

    my $zone = $zones->[0];
    my $next_pickup = $model->next_pickup($zone->name, 1, 'yes, datetime pls');
    my $pickup = $model->pickups->by_epoch($zone->name, $next_pickup->epoch);
    ok $pickup;
    is $pickup->pretty_day, 'Friday, June 5';
}

done_testing();
exit;
