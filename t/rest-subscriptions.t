#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use Recollect::APIController;
use JSON qw/encode_json decode_json/;

no warnings 'redefine';

my $app = t::Recollect->app('Recollect::APIController');
my $subscribe_url = '/subscriptions';
my $test_email = 'test@recollect.net';

# Rainy Day Subscription creation tests
my $cb;
test_psgi $app, sub {
    $cb = shift;

    sub bad_post_ok {
        my ($content_hash, $match, $desc) = @_;
        $desc ||= '';
        my $res = $cb->(POST $subscribe_url, $content_hash);
        is $res->code, 400, "$desc - status code";
        like $res->content, $match, "$desc - content"; 
        is $res->header('Content-Type'), 'application/json',
            "$desc content-type";
    }

    bad_post_ok({} => qr/Missing email/, 'no email present');
    bad_post_ok({ email => 'blur' } => qr/Bad email/, 'bad email address');
    bad_post_ok({ email => $test_email } => qr/Missing zone_id/,
        'no zone_id present');
    bad_post_ok(
        { email => $test_email, zone_id => 0xBEEF }, qr/Invalid zone_id/,
        'invalid zone_id'
    );

    bad_post_ok({ email => $test_email, zone_id => $test_zone_id }, qr/Missing target/,
        'no target present');
    bad_post_ok(
        { email => $test_email, zone_id => $test_zone_id, target => 'invalid' },
        qr/target is unsupported/,
        'invalid target present'
    );
};


# Create free reminder types
for my $target ("email:$test_email", "twitter:vanhackspace",
                "webhook:http://recollect.net/webhook-eg") {
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(POST $subscribe_url, {
                email => $test_email,
                target => $target,
                zone_id => $test_zone_id,
            }
        );
        is $res->code, 201, "create reminder - $target";
        ok $res->content =~ m{^{"id":"([\w-]+)"}$}, 'content contains id';
        my $reminder_id = $1;
        diag $res->content unless $reminder_id;
        warn $reminder_id;
        exit;
        $res = $cb->(GET "$subscribe_url/$reminder_id");
        is $res->code, 200;
        is $res->header('Content-Type'), 'application/json';
        my $blob = decode_json $res->content;
        ok !$blob->{payment_period}, 'free reminders have no payment_period';
        ok !$blob->{expiry}, 'free reminders have no expiry';
        $res = $cb->(DELETE "$subscribe_url/$reminder_id");
        is $res->code, 204, 'delete success';
        $res = $cb->(DELETE "$subscribe_url/$reminder_id");
        is $res->code, 400, 'cannot delete twice';
    };
    exit;
}


# Create Premium reminder types
for my $target (qw{voice:7787851357 sms:7787851357}) {
    test_psgi $app, sub {
        my $cb = shift;
        my $res = $cb->(POST $subscribe_url, 
            Content => encode_json(
                {
                    email => 'test@recollect.net',
                    name => 'Test',
                    target => $target,
                    payment_period => 'month',
                },
            ),
        );
        is $res->code, 201, "create reminder - $target";
        ok $res->header('Location') =~ m#^/zones/vancouver-north-blue/reminders/([\w-]+)$#;
        my $reminder_id = $1;
        ok $res->header('Content-Type') =~ m#json#;
        like $res->content, qr|{"payment_url":"https://www\.sandbox\.paypal.+fake-paypal-token"}|;
        $res = $cb->(GET "$subscribe_url/$reminder_id");
        is $res->code, 200;
        is $res->header('Content-Type'), 'application/json';
        my $blob = decode_json $res->content;
        is $blob->{payment_period}, 'month', 'monthly payment period';

        my $in_two_weeks = DateTime->today + DateTime::Duration->new(weeks=>2);
        is $blob->{expiry}, $in_two_weeks->epoch, 'expires in 2 weeks';

        # Pretend we just agreed on paypal and we are back.
        $res = $cb->(GET "/billing/proceed?token=fake-paypal-token");
        is $res->code, 200;
        like $res->content, qr/Thank you for subscribing/;

        # Now the paypal IPN comes in
        my $fake_ipn = {
            'payer_id' => 'TESTBUYERID01',
            'verify_sign' => 'AjPx9bf6MqOkbgZYNGr9bzU-kL1MAMVI76h9wdBoD7U561dLlB3yi4br',
            'residence_country' => 'US',
            'address_state' => 'CA',
            'mc_handling' => '2.06',
            'receiver_email' => 'seller@paypalsandbox.com',
            'item_number1' => 'AK-1234',
            'address_status' => 'confirmed',
            'payment_type' => 'instant',
            'address_city' => 'San Jose',
            'address_street' => '123, any street',
            'payment_status' => 'Completed',
            'mc_shipping1' => '1.02',
            'cmd' => '_notify-validate',
            'test_ipn' => '1',
            'txn_type' => 'recurring_payment_profile_created',
            'address_country' => 'United States',
            'charset' => 'windows-1252',
            'payment_date' => '22:23:24 Nov 17, 2010 PST',
            'mc_handling1' => '1.67',
            'invoice' => 'abc1234',
            'quantity1' => '1',
            'payer_status' => 'unverified',
            'mc_fee' => '0.44',
            'address_zip' => '95131',
            'custom' => $reminder_id,
            'txn_id' => '241118623',
            'last_name' => 'Smith',
            'receiver_id' => 'TESTSELLERID1',
            'address_country_code' => 'US',
            'mc_shipping' => '3.02',
            'payer_email' => 'buyer@paypalsandbox.com',
            'tax' => '2.02',
            'address_name' => 'John Smith',
            'notify_version' => '2.4',
            'mc_gross_1' => '9.34',
            'item_name1' => 'something',
            'mc_currency' => 'USD',
            'first_name' => 'John',
            'rp_invoice_id' => $reminder_id,
        };
        %Business::PayPal::IPN::TEST_DATA = ( %$fake_ipn, completed => 1);
        $res = $cb->(POST "/billing/ipn", [ %$fake_ipn ]);
        is $res->code, 200, $res->content;
        is $Business::PayPal::NVP::CHECKOUT{AMT}, '1.50';

        # Now check the expiry was bumped ahead
        $res = $cb->(GET "$subscribe_url/$reminder_id");
        is $res->code, 200;
        is $res->header('Content-Type'), 'application/json';
        $blob = decode_json $res->content;
        is $blob->{payment_period}, 'month', 'monthly payment period';
        my $next_expiry = DateTime->today 
                            + DateTime::Duration->new(months=>1, weeks => 1);
        is $blob->{expiry}, $next_expiry->epoch, 'expires in 1 month + 1 week';

        # Now delete the reminder
        $res = $cb->(DELETE "$subscribe_url/$reminder_id");
        is $res->code, 204;
        $res = $cb->(DELETE "$subscribe_url/$reminder_id");
        is $res->code, 400;

        # Coupon codes
        my $config = Recollect::Config->instance;
        $config->config_hash->{coupons}{test} = '10.00';
        $res = $cb->(POST $subscribe_url, 
            Content => encode_json(
                {
                    email => 'test@recollect.net',
                    name => 'Test',
                    target => $target,
                    payment_period => 'month',
                    coupon => 'test',
                },
            ),
        );
        is $res->code, 400, 'coupons must be on an annual reminder';
        $res = $cb->(POST $subscribe_url, 
            Content => encode_json(
                {
                    email => 'test@recollect.net',
                    name => 'Test',
                    target => $target,
                    payment_period => 'year',
                    coupon => 'test',
                },
            ),
        );
        is $res->code, 201, "create reminder - $target";

        # Pretend we just agreed on paypal and we are back.
        $res = $cb->(GET "/billing/proceed?token=fake-paypal-token");
        is $res->code, 200;
        is $Business::PayPal::NVP::CHECKOUT{AMT}, '10.00', 'coupon worked';
    };
}
done_testing();
