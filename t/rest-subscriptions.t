#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw/GET POST DELETE/;
use mocked 'Net::Recurly';
use t::Recollect;
use Recollect::APIController;
use Recollect::Subscription;
use Recollect::Notifier;
use JSON qw/encode_json decode_json/;

no warnings 'redefine';

my $app = t::Recollect->app('Recollect::APIController');
my $subscribe_url = '/subscriptions';
my $billing_url   = '/billing';
my $test_email    = 'test@recollect.net';
my $test_zone_id  = 1;

# Rainy Day Subscription creation tests
my $cb;
test_psgi $app, sub {
    $cb = shift;

    sub bad_post_ok {
        my ($content_hash, $match, $desc) = @_;
        $desc ||= '';
        my $res = $cb->(POST $subscribe_url,
            'Content-Type' => 'application/json',
            Content => encode_json($content_hash));
        
        is $res->code, 400, "$desc - status code";
        like $res->content, $match, "$desc - content"; 
        is $res->header('Content-Type'), 'application/json',
            "$desc content-type";
    }

    bad_post_ok({} => qr/Missing email/, 'no email present');
    bad_post_ok({ email => 'blur' } => qr/Bad email/, 'bad email address');
    bad_post_ok(
        { email => $test_email, } => qr/reminders missing/,
        'no reminders present'
    );
    bad_post_ok(
        { email => $test_email, reminders => [ ] } => qr/reminders missing/,
        'no reminders present'
    );
    bad_post_ok(
        { email => $test_email, reminders => [ {} ] } => qr/Missing zone_id/,
        'no zone_id present'
    );
    bad_post_ok(
        { email => $test_email, reminders => [ { zone_id => 0xBEEF } ] },
        qr/Invalid zone_id/,
        'invalid zone_id'
    );

    bad_post_ok(
        {
            email => $test_email,
            reminders => [ { zone_id => $test_zone_id } ]
        },
        qr/Missing target/,
        'no target present'
    );
    bad_post_ok(
        { email => $test_email, reminders => [ { zone_id => $test_zone_id, target => 'invalid' } ] },
        qr/target is unsupported/,
        'invalid target present'
    );
};


# Create free reminder types
for my $target ("email:$test_email", "twitter:vanhackspace",
                "webhook:http://recollect.net/webhook-eg") {
    my $subscription_id;
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(POST $subscribe_url, 
            'Content-Type' => 'application/json',
            Content => encode_json {
                email => $test_email,
                reminders => [
                    {
                        target => $target,
                        zone_id => $test_zone_id,
                        offset => 0,
                    }
                ],
            }
        );
        is $res->code, 201, "create reminder - $target";
        my $hash = decode_json $res->content;
        ok $hash->{id}, 'subscription has an id';
        ok !$hash->{payment_url}, 'free reminder has no payment url';
        ok $hash->{free}, 'reminder is free';
        ok $hash->{active}, 'free reminders are immediately active';
        is $hash->{reminders}[0]{delivery_offset}, '00:00:00', 'offset is correct';

    };
}

# Create Premium reminder types
for my $target (qw{voice:7787851357 sms:7787851357}) {
    my $subscription_id;
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(POST $subscribe_url, 
            'Content-Type' => 'application/json',
            Content => encode_json(
                {
                    email => 'test@recollect.net',
                    reminders => [
                        {
                            target => $target,
                            zone_id => $test_zone_id,
                            offset  => 0,
                        },
                    ],
                },
            ),
        );
        is $res->code, 201, "create reminder - $target";
        my $hash = decode_json $res->content;
        $subscription_id = $hash->{id};
        ok $subscription_id, 'subscription has an id';
        ok $hash->{payment_url}, 'non-free reminder has payment url';
        ok !$hash->{free}, 'non-free reminders are not free';
        ok !$hash->{active}, 'non-free reminders are not active initially';

        is $hash->{reminders}[0]{delivery_offset}, '00:00:00', 'offset is correct';
    };

    Subscription_has_not_been_paid: {
        my $subscr = Recollect::Subscription->By_id($subscription_id);
        ok $subscr, 'subscription object exists';
        ok !$subscr->active, 'subscription has not been paid';
    }

    test_psgi $app, sub {
        my $cb = shift;
        local $Net::Recurly::STATE = 'active';
        my $res = $cb->(POST $billing_url, 
            'Content-Type' => 'application/xml',
            Content => <<EOT,
<?xml version="1.0" encoding="UTF-8"?><new_subscription_notification><account><account_code>$subscription_id</account_code><username>test\@5thplane.com</username><email>test\@5thplane.com</email><first_name>first</first_name><last_name>last</last_name><company_name></company_name></account><subscription><plan><plan_code>vancouver</plan_code><name>Vancouver Reminder</name></plan><state>active</state><quantity type="integer">1</quantity><total_amount_in_cents type="integer">500</total_amount_in_cents><activated_at type="datetime">2011-01-02T07:06:56Z</activated_at><canceled_at nil="true" type="datetime"></canceled_at><expires_at nil="true" type="datetime"></expires_at><current_period_started_at type="datetime">2011-01-02T07:06:56Z</current_period_started_at><current_period_ends_at type="datetime">2011-04-02T07:06:56Z</current_period_ends_at><trial_started_at nil="true" type="datetime"></trial_started_at><trial_ends_at nil="true" type="datetime"></trial_ends_at></subscription></new_subscription_notification>
EOT
        );
        is $res->code, 200, "payment notification";
        diag $res->content unless $res->code eq 200;
    };

    Subscription_has_now_been_paid: {
        my $subscr = Recollect::Subscription->By_id($subscription_id);
        ok $subscr, 'subscription object exists';
        ok $subscr->active, 'subscription has now been paid';
        ok !$subscr->free, 'non-free reminders are not free';
    }

    Subscription_is_cancelled: {
        test_psgi $app, sub {
            my $cb = shift;
            local $Net::Recurly::STATE = 'canceled';
            my $res = $cb->(POST $billing_url, 
                'Content-Type' => 'application/xml',
                Content => <<EOT,
<?xml version="1.0" encoding="UTF-8"?><canceled_subscription_notification><account><account_code>$subscription_id</account_code><username>test\@5thplane.com</username><email>test\@5thplane.com</email><first_name>first</first_name><last_name>last</last_name><company_name></company_name></account><subscription><plan><plan_code>vancouver</plan_code><name>Vancouver Reminder</name></plan><state>canceled</state><quantity type="integer">1</quantity><total_amount_in_cents type="integer">500</total_amount_in_cents><activated_at type="datetime">2011-01-02T07:06:56Z</activated_at><canceled_at nil="true" type="datetime"></canceled_at><expires_at nil="true" type="datetime"></expires_at><current_period_started_at type="datetime">2011-01-02T07:06:56Z</current_period_started_at><current_period_ends_at type="datetime">2011-04-02T07:06:56Z</current_period_ends_at><trial_started_at nil="true" type="datetime"></trial_started_at><trial_ends_at nil="true" type="datetime"></trial_ends_at></subscription></canceled_subscription_notification>
EOT
            );
            is $res->code, 200, "payment notification";
            diag $res->content unless $res->code eq 200;
        };
    }

    Subscription_is_no_longer_active: {
        my $subscr = Recollect::Subscription->By_id($subscription_id);
        ok $subscr, 'subscription object exists';
        ok !$subscr->active, 'when cancelled, subscription is not active';
    }

}
done_testing();
