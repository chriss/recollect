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

Recollect::Util->run_sql('DELETE FROM trials');

@WWW::Twilio::API::POSTS = ();
subtest "Trial SMS" => sub {
    request_trial('sms:6048073906' => 204);
    my $count = Recollect::Util->sql_singlevalue('SELECT COUNT(*) FROM trials');
    is $count, 1, 'recorded a trial request';
    is scalar(@WWW::Twilio::API::POSTS), 1, 'twilio sent a sms';
};

@WWW::Twilio::API::POSTS = ();
subtest "Limit 2 per target" => sub {
    request_trial('sms:6048073906' => 204);
    my $count = Recollect::Util->sql_singlevalue('SELECT COUNT(*) FROM trials');
    is $count, 2, 'recorded a trial request';
    is scalar(@WWW::Twilio::API::POSTS), 1, 'twilio sent a sms';
    request_trial('sms:6048073906' => 403);
    is scalar(@WWW::Twilio::API::POSTS), 1, 'twilio sent a sms';
};

@WWW::Twilio::API::POSTS = ();
subtest "Trial Voice" => sub {
    request_trial('voice:6048073906' => 204);
    my $count = Recollect::Util->sql_singlevalue('SELECT COUNT(*) FROM trials');
    is $count, 3, 'recorded a trial request';
    is scalar(@WWW::Twilio::API::POSTS), 1, 'twilio sent a sms';
};

subtest "Email, Twitter not supported" => sub {
    request_trial('twitter:6048073906' => 400);
    request_trial('email:6048073906'   => 400);
    request_trial('webhook:6048073906' => 400);
};

done_testing();
exit;

sub request_trial {
    my $target  = shift;
    my $code    = shift;
    test_psgi $app, sub {
        my $cb = shift;

        my $res = $cb->(POST "/areas/Vancouver/zones/vancouver-north-blue/trial",
            'Content-Type' => 'application/x-www-form-urlencoded',
            Content => "target=$target",
        );
        is $res->code, $code, "POST returns $code";
        diag $res->content if $res->code != $code;
    }
}

