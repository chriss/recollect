#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use JSON qw/encode_json decode_json/;

no warnings 'redefine';
no warnings 'once';

use_ok 'Recollect::APIController';
my ($test_version) = $Recollect::APIController::API_Version = '1.42';
my $vancouver_latlng = '49.26422,-123.138542';

my $app = t::Recollect->app('Recollect::APIController');

test_html_txt_json(
    '/version',
    html => sub {
        my $content = shift;
        like $content, qr/<body>/,        'html has a body tag';
        like $content, qr/$test_version/, 'html contains the API Version';
    },
    text => sub {
        my $content = shift;
        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
        like $content, qr/^API Version: $test_version$/,
            'text contains version';
    },
    json => sub {    # JSON tests
        my $data = shift;
        is $data->[0]{name}, 'API Version', 'json has api name';
        is $data->[0]{value}, $test_version, 'json has api version';
    },
);


# GET /api/areas
test_html_txt_json(
    '/areas',
    html => sub {
        my $content = shift;
        like $content, qr/<body>/,        'html has a body tag';
        like $content, qr/Recollect Areas/;
        like $content, qr/Vancouver/;
    },
    text => sub {
        my $content = shift;
        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
        is $content, "1 - Vancouver: $vancouver_latlng\n";
    },
    json => sub {    # JSON tests
        my $data = shift;
        is ref($data), 'ARRAY';
        is scalar(@$data), 1;
        is $data->[0]{name}, 'Vancouver';
    },
);

# GET /api/areas/:area
#    * :area can be id or Vancouver or vancouver
Area_tests: {
    my %tests = (
        html => sub {
            my $content = shift;
            like $content, qr/Area - Vancouver/;
            like $content, qr/<body>/,        'html has a body tag';
            like $content, qr/$vancouver_latlng/;
        },
        text => sub {
            my $content = shift;
            unlike $content, qr/<\w+.+?>/, 'text has no html tags';
            is $content,
                "id: 1\nname: Vancouver\ncentre: $vancouver_latlng\n";
        },
        json => sub {    # JSON tests
            my $data = shift;
            is $data->{id},     1;
            is $data->{name},   'Vancouver';
            is $data->{centre}, $vancouver_latlng;
        },
    );
    test_html_txt_json('/areas/1',         %tests);
    test_html_txt_json('/areas/Vancouver', %tests);
    test_html_txt_json('/areas/vancouver', %tests);
}

test_html_txt_json(
    '/areas/Vancouver/zones',
    html => sub {
        my $content = shift;
        like $content, qr/Recollect Zones in Vancouver/;
        like $content, qr/north-blue/;
        like $content, qr/north-green/;
        like $content, qr/north-red/;
        like $content, qr/north-yellow/;
        like $content, qr/north-purple/;
        like $content, qr/south-blue/;
        like $content, qr/south-green/;
        like $content, qr/south-red/;
        like $content, qr/south-yellow/;
        like $content, qr/south-purple/;
    },
    text => sub {
        my $content = shift;
        like $content, qr/^\d+ - vancouver-north-blue: Vancouver North Blue/;
    },
    json => sub {    # JSON tests
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is scalar(@$data), 10;
        $data = [ sort { $a->{name} cmp $b->{name} } @$data ];
        is $data->[0]{name}, 'vancouver-north-blue';
    },
);

# GET /api/areas/:area/zones/:zone
#    * should include pickupdays + nextpickup
# GET /api/areas/:area/zones/:zone/pickupdays +ics
# GET /api/areas/:area/zones/:zone/nextpickup
# GET /api/areas/:area/zones/:zone/nextdowchange
# GET /api/areas/:area/zones/:lat,:lng(.+)

done_testing();

exit;

sub test_html_txt_json {
    my $uri   = shift;
    my %tests = @_;

    subtest "GET $uri" => sub {
        test_psgi $app, sub {
            my $cb = shift;

            my $test_uri = sub {
                my $uri        = shift;
                my $test_block = shift;
                diag "GET $uri";
                my $res = $cb->(GET $uri);
                is $res->code, 200;
                diag $res->content if $res->code == 500;
                $test_block->($res->content, @_);
            };
            if (my $test = $tests{html}) {
                $test_uri->($uri, $test);
            }
            if (my $test = $tests{text}) {
                $test_uri->($uri . '.txt', $test);
            }
            if (my $test = $tests{json}) {
                $test_uri->(
                    $uri . '.json',
                    sub {
                        my $json = shift;
                        my $data = eval { decode_json($json) };
                        is $@, '', "json is valid";
                        $test->($data) unless $@;
                    }
                );
            }
        };
    };
}

