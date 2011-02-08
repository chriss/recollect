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

use_ok 'Recollect::APIController';

test_interest('Surrey');

exit;

sub test_interest {
    my $area  = shift;
    my %tests = @_;
    my $app = t::Recollect->app('Recollect::APIController');

    my $uri = "/interest/$area";
    subtest "GET $uri" => sub {
        test_psgi $app, sub {
            my $cb = shift;

            my $res = $cb->(GET $uri);
            is $res->code, 200, "GET $uri returns 200";
            diag $res->content if $res->code != 200;
        }
    };
}

