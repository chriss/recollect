#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use Recollect::Subscription;
use Recollect::Zone;

my $test_email = 'test@recollect.net';
t::Recollect->model(); # create the model & database

Add_a_free_subscription: {
    my $zones = Recollect::Zone->All;
    isa_ok $zones, 'ARRAY';
    @$zones = sort { $a->{name} cmp $b->{name} } @$zones;
    my $zone = shift @$zones;

    is scalar(@{ Recollect::Subscription->All }), 0, 'no Subscriptions';
    my $subscr = Recollect::Subscription->Create(
        email => $test_email,
        reminders => [
            {
                target => "email:$test_email",
                zone_id => $zone->id,
                offset => '-12',
            },
        ],
    );

    like $subscr->id,  qr/^[\w\d-]+$/, 'id';
    is $subscr->user->email, 'test@recollect.net', 'sub has the user';
    ok $subscr->free, 'sub is free';
    my $rems = $subscr->reminders;
    isa_ok $rems, 'ARRAY', 'sub has reminders';
    is scalar(@$rems), 1, 'sub has one reminder';
    my $hash = $rems->[0]->to_hash;
    is $hash->{target}, "email:$test_email", 'rem target is correct';
    is $hash->{zone}{id}, $zone->id, 'rem zone is correct';
    is $rems->[0]->subscription->id, $subscr->id, 'rem sub id is correct';
    ok $rems->[0]->subscription->free, 'rem sub is free';

    is scalar(@{ Recollect::Subscription->All }), 1, 'one Subscriptions';
}

# TOTEST: paid subscription

exit;

# TOTEST: rainy day (bad email, bad zone)

Confirm_reminder: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    $rems->[0]->confirmed(1);
    $rems->[0]->update;
    ok $rems->[0]->confirmed, 'confirmed';
}

Delete_reminder: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    $rems->[0]->delete;
    $rems = $model->reminders->all;
    is scalar(@$rems), 0, 'no reminders';
}

done_testing();
exit;

