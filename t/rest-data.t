#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use JSON qw/encode_json decode_json/;

no warnings 'redefine';

use_ok 'Recollect::APIController';

# /api/version
# /api/areas
# /api/areas/lat,lang
# /api/areas/:area
# /api/areas/:area/zones
# /api/areas/:area/zones/pickupdays +ics
# /api/areas/:area/zones/nextpickup
# /api/areas/:area/zones/nextdowchange

my $app = t::Recollect->app('Recollect::APIController');
test_html_txt_json('/version',
    html => sub {
        my $content = shift;
        like $content, qr/API Version/;
    },
    text => sub {
        my $content = shift;
        like $content, qr/^API Version/;
    },
    json => sub { # JSON tests
        my $data = shift;
    },
);

done_testing();

exit;

sub test_html_txt_json {
    my $uri = shift;
    my %tests = @_;

    test_psgi $app, sub {
        my $cb = shift;

        if (my $test = $tests{html}) {
            my $res = $cb->(GET $uri);
            is $res->code, 200;
            diag $res->content if $res->code == 500;
            $test->($res->content);
        }
        if (my $test = $tests{text}) {
            my $res = $cb->(GET $uri . '.txt');
            is $res->code, 200;
            diag $res->content if $res->code == 500;
            $test->($res->content);
        }
        if (my $test = $tests{json}) {
            my $res = $cb->(GET $uri . '.json');
            is $res->code, 200;
            diag $res->content if $res->code == 500;
            my $data = eval { decode_json($res->content) };
            is $@, '', "json is valid";
            $test->($res->content);
        }
    };
}


