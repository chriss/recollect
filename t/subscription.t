#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use Recollect::Subscription;
use Recollect::Zone;

my $test_email = 'test@recollect.net';
t::Recollect->model();    # create the model & database

Add_a_free_subscription: {
    my $zones = Recollect::Zone->All;
    isa_ok $zones, 'ARRAY';
    @$zones = sort { $a->{name} cmp $b->{name} } @$zones;
    my $zone = shift @$zones;

    is scalar(@{ Recollect::Subscription->All }), 0, 'no Subscriptions';
    my $subscr = Recollect::Subscription->Create(
        email     => $test_email,
        reminders => [
            {
                target  => "email:$test_email",
                zone_id => $zone->id,
                offset  => '-12',
            },
        ],
    );

    like $subscr->id, qr/^[\w\d-]+$/, 'id';
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
    is $rems->[0]->subscription->payment_url, undef, 'no payment url';
    is $rems->[0]->subscription->last_payment, undef, 'no payment has been made';

    is scalar(@{ Recollect::Subscription->All }), 1, 'one Subscriptions';
}

Add_a_paid_subscription: {
    my $zones = Recollect::Zone->All;
    my $zone  = shift @$zones;

    is scalar(@{ Recollect::Subscription->All }), 1,
        'one previous Subscriptions';
    my $subscr = Recollect::Subscription->Create(
        email     => $test_email,
        reminders => [
            {
                target  => "sms:$test_email",
                zone_id => $zone->id,
                offset  => '-12',
            },
        ],
    );

    like $subscr->id, qr/^[\w\d-]+$/, 'id';
    is $subscr->user->email, 'test@recollect.net', 'sub has the user';
    ok !$subscr->free, 'sub is not free';
    my $rems = $subscr->reminders;
    isa_ok $rems, 'ARRAY', 'sub has reminders';
    is scalar(@$rems), 1, 'sub has one reminder';
    my $hash = $rems->[0]->to_hash;
    is $hash->{target}, "sms:$test_email", 'rem target is correct';
    is $hash->{zone}{id}, $zone->id, 'rem zone is correct';
    is $rems->[0]->subscription->id, $subscr->id, 'rem sub id is correct';
    ok !$rems->[0]->subscription->free, 'rem sub is not free';
    is $rems->[0]->subscription->payment_url,
        'https://recollect-test.recurly.com/subscribe/vancouver/'
            . $rems->[0]->subscription->id
            . '/test@recollect.net?email=test@recollect.net',
        'payment url is correct';
    is $rems->[0]->subscription->last_payment, undef, 'no payment has been made';

    # Now pretend a payment came in
    $rems->[0]->subscription->payment_received;
    ok $rems->[0]->subscription->last_payment, 'payment has been made';

    is scalar(@{ Recollect::Subscription->All }), 2, 'one new Subscriptions';
}

Rainy_day_subscription_creation: {
    my $zones = Recollect::Zone->All;
    my $zone  = shift @$zones;

    is scalar(@{ Recollect::Subscription->All }), 2, 'two to start with';
    eval {
        Recollect::Subscription->Create(
            email     => $test_email,
            reminders => [
                {
                    target  => "sms:$test_email",
                    zone_id => 0xBEEF,
                    offset  => '-12',
                },
            ],
        );
    };
    like $@, qr/violates foreign key constraint/, 'bad email is handled';
}

# To Test:
# * Confirm
# * Delete

done_testing();
exit;

