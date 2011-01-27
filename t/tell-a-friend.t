#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use DateTime::Functions;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use JSON qw/encode_json decode_json/;
use Data::ICal;

no warnings 'redefine';
no warnings 'once';

use_ok 'Recollect::Controller';
my ($test_version) = $Recollect::APIController::API_Version = '1.42';
my $vancouver_latlng = '49.26422,-123.138542';

test_tell_a_friend(
    desc => "empty form post",
    after => sub {
        my $res = shift;
        t::Recollect::log_like(qr/TELLAFRIEND_FAIL - skilltest/,
            'empty form post');
        like $res->content, qr/skill testing question/i, 'skill testing';
    },
);

test_tell_a_friend(
    desc => "really incomplete form post",
    postdata => [
        Content => [ skilltesting => 'bc' ],
    ],
    after => sub {
        my $res = shift;
        t::Recollect::log_like(qr/TELLAFRIEND_FAIL - incomplete form/,
            'really incomplete form post');
        like $res->content, qr/fill out both/i, 'incomplete';
    },
);

test_tell_a_friend(
    desc => "incomplete form post - no sender",
    postdata => [
        Content => [
            skilltesting => 'bc',
            friend_emails => 'tell-a-friend-test@recollect.net',
        ],
    ],
    after => sub {
        my $res = shift;
        t::Recollect::log_like(qr/TELLAFRIEND_FAIL - incomplete form/,
            'really incomplete form post');
        like $res->content, qr/fill out both/i, 'incomplete';
    },
);

test_tell_a_friend(
    desc => "incomplete form post - no recips",
    postdata => [
        Content => [
            skilltesting => 'bc',
            sender_email => 'tell-a-friend-test@recollect.net',
        ],
    ],
    after => sub {
        my $res = shift;
        t::Recollect::log_like(qr/TELLAFRIEND_FAIL - incomplete form/,
            'really incomplete form post');
        like $res->content, qr/fill out both/i, 'incomplete';
    },
);

test_tell_a_friend(
    desc => "sunny day",
    postdata => [
        Content => [
            skilltesting => 'bc',
            sender_email => 'tell-a-friend-sender-test@recollect.net',
            friend_emails =>
                'tell-a-friend-test@recollect.net, '
                . 'tell-another-friend-test@recollect.net',
            ],
    ],
    after => sub {
        my $res = shift;
        t::Recollect::log_like(qr/TELLAFRIEND 2/, 'log ok');
        like $res->content, qr/Email sent./i, 'message ok';
        my $email = t::Recollect::email_content();
        like $email, qr/From: tell-a-friend-sender-test\@recollect\.net/;
        like $email, qr/To: tell-another-friend-test\@recollect\.net/;
        like $email, qr/To: tell-a-friend-test\@recollect\.net/;
    },
);

done_testing();

exit;

sub test_tell_a_friend {
    my %opts = @_;
    my $uri  = "/action/tell-friends";
    my $app  = t::Recollect->app('Recollect::Controller');

    t::Recollect::clear_email();
    t::Recollect::clear_twitters();
    subtest $opts{desc} => sub {
        test_psgi $app, sub {
            my $cb = shift;

            my $res = $cb->(POST $uri, 
                'Content-Type' => 'application/x-www-form-urlencoded',
                @{ $opts{postdata} || [] },
            );
            is $res->code, 200, "POST $uri returns 200";
            diag $res->content if $res->code == 500;
            $opts{after}->($res) if $opts{after};
        };
    };
}

