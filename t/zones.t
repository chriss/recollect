#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use Recollect::Zone;

Set_now_time: {
    my $model = t::Recollect->model;

    # Set the time to right before a day change
    my $now = $model->now;
    $now->set(
        month => 12,
        day => 7,
        year => 2010,
    );
    $ENV{RECOLLECT_NOW} = $now;
}

my $redzone = Recollect::Zone->By_name('vancouver-south-red');
Next_pickup: {
    my $np = $redzone->next_pickup->[0];
    is $np->ymd, '2010-12-08', 'next-pickup';
    is $np->flags, 'Y', 'date has correct flags';
}

Next_pickups: {
    my $np = $redzone->next_pickup(3);
    is $np->[0]->ymd, '2010-12-08', 'next-pickup';
    is $np->[0]->flags, 'Y', 'date has correct flags';
    is $np->[1]->ymd, '2010-12-15', 'next-pickup';
    is $np->[1]->flags, '', 'date has correct flags';
    is $np->[2]->ymd, '2010-12-22', 'next-pickup';
    is $np->[2]->flags, 'Y', 'date has correct flags';
}

Next_dow_change: {
    my $np = $redzone->next_dow_change;
    is $np->{last}->string, '2010-12-22 Y', 'last pickup is correct';
    is $np->{next}->string, '2010-12-31', 'next pickup is correct';
}

done_testing();
exit;

