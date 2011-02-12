#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use DateTime::Functions;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use JSON qw/encode_json decode_json/;
use Recollect::Util;
use Data::ICal;

no warnings 'redefine';
no warnings 'once';

use_ok 'Recollect::APIController';
my $app = t::Recollect->app('Recollect::APIController');
ok $app, 'have an app';

Recollect::Util->run_sql('DELETE FROM place_interest');
Recollect::Util->run_sql('DELETE FROM place_notify');

subtest "Requesting notification for service in a place" => sub {
    test_notification_ok('49.2877347,-123.0452854', 'email@foobar.com');
    test_notification_ok('49.2877347,-123.0452854', 'this is not an email address');

    my $count = Recollect::Util->sql_singlevalue('SELECT COUNT(*) FROM place_notify');
    is $count, 1, 'recorded a real email';
};

done_testing();
exit;

sub test_interest_ok {
    my $area  = shift;
    test_psgi $app, sub {
        my $cb = shift;

        my $res = $cb->(GET "/interest/$area");
        is $res->code, 204, "GET returns 204";
        diag $res->content if $res->code != 204;
    }
}

sub test_notification_ok {
    my $area  = shift;
    my $email = shift;
    test_psgi $app, sub {
        my $cb = shift;

        my $res = $cb->(POST "/interest/$area/notify",
            'Content-Type' => 'application/x-www-form-urlencoded',
            Content => "email=$email",
        );
        is $res->code, 204, "POST returns 204";
        diag $res->content if $res->code != 204;
    }
}

