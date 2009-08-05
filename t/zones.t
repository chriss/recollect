#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::VanTrash;

my $model = t::VanTrash->model;

# Set the time to right before a day change
my $now = $model->now;
$now->set(
    month => 9,
    day => 1,
    year => 2009,
);
$ENV{VANTRASH_NOW} = $now;

Next_pickup: {
    my $np = $model->next_pickup('vancouver-south-red', 1, 'datetime');
    is $np->ymd, '2009-09-03', 'next-pickup';
}

Next_dow_change: {
    my ($last, $first) = $model->next_dow_change('vancouver-south-red');
    is $last->ymd,  '2009-09-03', 'next-day-change';
    is $first->ymd, '2009-09-11', 'next-day-change';
    $ENV{VANTRASH_NOW}->set( day => 11 );
    ($last, $first) = $model->next_dow_change('vancouver-south-red');
    is $last->ymd,  '2009-10-09', 'next-day-change';
    is $first->ymd, '2009-10-19', 'next-day-change';
}


done_testing();
exit;

