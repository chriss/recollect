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
my $test_zone_id = 1;

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
                        offset => '6',
                    }
                ],
            }
        );
        is $res->code, 201, "create reminder - $target";
        my $hash = decode_json $res->content;
        my $subscription_id = $hash->{id};
        ok $subscription_id, 'subscription has an id';
        ok !$hash->{payment_url}, 'free reminder has no payment url';
    };
}

# Create Premium reminder types
for my $target (qw{voice:7787851357 sms:7787851357}) {
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
                            offset  => 6,
                        },
                    ],
                },
            ),
        );
        is $res->code, 201, "create reminder - $target";
        my $hash = decode_json $res->content;
        my $subscription_id = $hash->{id};
        ok $subscription_id, 'subscription has an id';
        ok $hash->{payment_url}, 'non-free reminder has payment url';
    };
}
done_testing();
