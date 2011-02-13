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
    is $np->flags, '', 'date has correct flags';
}

Next_pickups: {
    my $np = $redzone->next_pickup(3);
    is $np->[0]->ymd, '2011-01-17', 'next-pickup';
    is $np->[0]->flags, '', 'date has correct flags';
    is $np->[1]->ymd, '2011-01-24', 'next-pickup';
    is $np->[1]->flags, 'Y', 'date has correct flags';
    is $np->[2]->ymd, '2011-01-31', 'next-pickup';
    is $np->[2]->flags, '', 'date has correct flags';
}

Next_dow_change: {
    my $np = $redzone->next_dow_change;
    is $np->{last}->string, '2011-04-18 Y', 'last pickup is correct';
    is $np->{next}->string, '2011-04-27', 'next pickup is correct';
}

ok 0, 'intentional failure; please ignore';

done_testing();
exit;

