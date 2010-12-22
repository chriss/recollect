#!/usr/bin/perl
use strict;
use warnings;
use Plack::Test;
use Test::More;
use HTTP::Request::Common qw/GET POST DELETE/;
use t::Recollect;
use JSON qw/encode_json decode_json/;
use Data::ICal;

no warnings 'redefine';
no warnings 'once';

use_ok 'Recollect::APIController';
my ($test_version) = $Recollect::APIController::API_Version = '1.42';
my $vancouver_latlng = '49.26422,-123.138542';

my $app = t::Recollect->app('Recollect::APIController');

test_the_api_for(
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
    json => sub {
        my $data = shift;
        is $data->[0]{name}, 'API Version', 'json has api name';
        is $data->[0]{value}, $test_version, 'json has api version';
    },
);


# GET /api/areas
test_the_api_for(
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
    json => sub {
        my $data = shift;
        is ref($data), 'ARRAY';
        is scalar(@$data), 1;
        is $data->[0]{name}, 'Vancouver';
    },
);

# GET /api/areas/:area
#    * :area can be id or Vancouver or vancouver
Area_tests: {
    my %area_tests = (
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
        json => sub {
            my $data = shift;
            is $data->{id},     1;
            is $data->{name},   'Vancouver';
            is $data->{centre}, $vancouver_latlng;
        },
    );
    test_the_api_for('/areas/1',         %area_tests);
    test_the_api_for('/areas/Vancouver', %area_tests);
    test_the_api_for('/areas/vancouver', %area_tests);
}

test_the_api_for(
    '/areas/Vancouver/zones',
    html => sub {
        my $content = shift;
        like $content, qr/<body>/, 'html has a body tag';
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
        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
        like $content, qr/^\d+ - vancouver-north-blue: Vancouver North Blue/;
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is scalar(@$data), 10;
        $data = [ sort { $a->{name} cmp $b->{name} } @$data ];
        is $data->[0]{name}, 'vancouver-north-blue';
    },
);

# GET /api/areas/:area/zones/:zone
my %zone_tests = (
    html => sub {
        my $content = shift;
        like $content, qr/Zone - Vancouver North Red in Vancouver/;
        like $content, qr/<body>/, 'html has a body tag';
        like $content, qr{>Pickup Days</a>}, 'html has a link to Pickup Days';
        like $content, qr{>Next Pickup</a>}, 'html has a link to Next Pickup';
    },
    text => sub {
        my $content = shift;
        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
        is $content, <<EOT, 'text content';
id: 1
name: vancouver-north-red
title: Vancouver North Red
EOT
    },
    json => sub {
        my $data = shift;
        is $data->{id},    1;
        is $data->{name},  'vancouver-north-red';
        is $data->{title}, 'Vancouver North Red';
        ok !$data->{pickupdays}, 'no pickupdays, not verbose';
        ok !$data->{nextpickup}, 'no nextpickup, not verbose';
    },
);
test_the_api_for('/areas/Vancouver/zones/1',                   %zone_tests);
test_the_api_for('/areas/Vancouver/zones/vancouver-north-red', %zone_tests);

test_the_api_for('/areas/Vancouver/zones/vancouver-north-red?verbose=1',
    json => sub {
        my $data = shift;
        is $data->{id},    1;
        is $data->{name},  'vancouver-north-red';
        is $data->{title}, 'Vancouver North Red';
        isa_ok $data->{pickupdays}, 'ARRAY', 'pickupdays should be an arrayref';
        isa_ok $data->{nextpickup}, 'HASH', 'nextpickup should be an hashref';
    },
);

# GET /api/areas/:area/zones/:zone/pickupdays
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-red/pickupdays',
    html => sub {
        my $content = shift;
        like $content, qr/<body>/, 'html has a body tag';
        like $content, qr/2010-12-15 Y/, 'html has a date';
    },
    text => sub {
        my $content = shift;
        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
        like $content, qr/^2010-01-08\n/, 'text has a date';
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is $data->[0]{day}, '2010-01-08', 'json has a day';
        like $data->[0]{zone_id}, qr/^\d+$/, 'json has a zone_id';
        is $data->[0]{string}, '2010-01-08', 'json has a string form';
        is $data->[0]{flags}, '', 'json has flags';
        is $data->[1]{string}, '2010-01-15 Y', 'json has a string form';
        is $data->[1]{flags}, 'Y', 'json has flags';
    },
);

# GET /api/areas/:area/zones/:zone/pickupdays.ics
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-red/pickupdays',
    ics => sub {
        my $ical = shift;
        my $entries = $ical->entries;
        is scalar(@$entries), 58;
    },
);

# GET /api/areas/:area/zones/:zone/nextpickup
# GET /api/areas/:area/zones/:zone/nextdowchange
# GET /api/areas/:area/zones/:lat,:lng(.+)

done_testing();

exit;

sub test_the_api_for {
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
            if (my $test = $tests{ics}) {
                $test_uri->($uri . '.ics', sub {
                        my $text = shift;
                        my $ical = Data::ICal->new(data => $text);
                        $test->($ical);
                    },
                );
            }
            if (my $test = $tests{json}) {
                $uri =~ s/(\?(.+)$|$)/.json$1/;
                $test_uri->(
                    $uri,
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

