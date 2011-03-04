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
use XML::Simple;

no warnings 'redefine';
no warnings 'once';

use_ok 'Recollect::APIController';
my ($test_version) = $Recollect::APIController::API_Version = '1.42';
my $vancouver_latlng = '49.26422,-123.138542';

test_the_api_for(
    '/version',
    html => sub {
        my $content = shift;
        like $content, qr/$test_version/, 'html contains the API Version';
    },
    text => sub {
        my $content = shift;
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
my $Vancouver_area_id = Recollect::Area->By_name('Vancouver')->id;
test_the_api_for(
    '/areas',
    html => sub {
        my $content = shift;
        like $content, qr/Recollect Areas/;
        like $content, qr/Vancouver/;
    },
    text => sub {
        my $content = shift;
        is $content, "$Vancouver_area_id - Vancouver: $vancouver_latlng\n";
    },
    json => sub {
        my $data = shift;
        is ref($data), 'ARRAY';
        is scalar(@$data), 1;
        is $data->[0]{name}, 'Vancouver';
    },
);

# POST /api/areas - create a new area
test_the_post_api(
    '/areas',
    {
        name => 'Victoria',
        centre => '49.891235,-97.15369',
    },
    sub {
        my $data = shift;
        ok $data->{id}, 'has an id';
    },
);

# GET /api/areas/:area
#    * :area can be id or Vancouver or vancouver
Area_tests: {
    my %area_tests = (
        html => sub {
            my $content = shift;
            like $content, qr/Area - Vancouver/;
            like $content, qr/$vancouver_latlng/;
        },
        text => sub {
            my $content = shift;
            is $content,
                "id: $Vancouver_area_id\nname: Vancouver\ncentre: $vancouver_latlng\n";
        },
        json => sub {
            my $data = shift;
            is $data->{id},     $Vancouver_area_id;
            is $data->{name},   'Vancouver';
            is $data->{centre}, $vancouver_latlng;
        },
        kml => sub {
            my $data = shift;
            like $data->{Document}{name}, qr/Area - Vancouver$/;
            my $styles = $data->{Document}{Style};
            for my $c (qw/green red blue yellow purple/) {
                for my $d (qw/north south/) {
                    my $name = "vancouver-$d-$c-$c";
                    ok $styles->{$name}{PolyStyle}{color}, "$c polycolour";
                    ok $styles->{$name}{LineStyle}{color}, "$c linecolour";
                }
            }

            my $polygons = $data->{Document}{Placemark};
            is scalar(keys %$polygons), 10, 'found 10 places';
            for my $id (keys %$polygons) {
                my $p = $polygons->{$id};
                ok $p->{styleUrl}, "$id styleUrl";
                ok $p->{description}, "$id description";
                my $coords = $p->{Polygon}{outerBoundaryIs}{LinearRing}{coordinates};
                ok $coords, "$id coords";
                unlike $coords, qr/\(|\)/, 'no parens';
            }
        },
    );
    test_the_api_for("/areas/$Vancouver_area_id",         %area_tests);
    test_the_api_for('/areas/Vancouver', %area_tests);
    test_the_api_for('/areas/vancouver', %area_tests);
}

test_the_api_for(
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
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is scalar(@$data), 10;
        $data = [ sort { $a->{name} cmp $b->{name} } @$data ];
        is $data->[0]{name}, 'vancouver-north-blue';
    },
);

# GET /api/areas/:area/zones/:zone
my $North_red_id = Recollect::Zone->By_name('vancouver-north-red')->id;
my %zone_tests = (
    html => sub {
        my $content = shift;
        like $content, qr/Zone - Vancouver North Red in Vancouver/;
        like $content, qr{>Pickup Days</a>}, 'html has a link to Pickup Days';
        like $content, qr{>Next Pickup</a>}, 'html has a link to Next Pickup';
    },
    text => sub {
        my $content = shift;
        is $content, <<EOT, 'text content';
id: $North_red_id
name: vancouver-north-red
title: Vancouver North Red
area_name: Vancouver
area_id: $Vancouver_area_id
city_name: Vancouver
licence_url: http://data.vancouver.ca/termsOfUse.htm
ad_img: recollect-ad-no-plastic-borderless.jpg
EOT
    },
    json => sub {
        my $data = shift;
        is $data->{id},    $North_red_id;
        is $data->{name},  'vancouver-north-red';
        is $data->{title}, 'Vancouver North Red';
        is $data->{city}{name}, 'Vancouver';
        is $data->{city}{licence_url},'http://data.vancouver.ca/termsOfUse.htm';
        is $data->{city}{ad_img}, 'recollect-ad-no-plastic-borderless.jpg';
        ok $data->{pickupdays}, 'pickupdays';
        ok $data->{nextpickup}, 'nextpickup';
    },
    kml => sub {
        my $data = shift;
        like $data->{Document}{name}, qr/Vancouver North Red/;
        is $data->{Document}{Placemark}{styleUrl}, '#vancouver-north-red-red';
        is $data->{Document}{Placemark}{name}, 'vancouver-north-red';
        is $data->{Document}{Placemark}{description}, 'Vancouver North Red';
        is $data->{Document}{Style}{PolyStyle}{color}, '336565ff';
        is $data->{Document}{Style}{LineStyle}{color}, 'ff3333ff';
        is $data->{Document}{Style}{id}, 'vancouver-north-red-red';
        my $coords = $data->{Document}{Placemark}{Polygon}
                            ->{outerBoundaryIs}{LinearRing}{coordinates};
        like $coords, qr/49/;
    },
);

test_the_api_for("/areas/Vancouver/zones/$North_red_id",                   %zone_tests);
test_the_api_for('/areas/Vancouver/zones/vancouver-north-red', %zone_tests);

# GET /api/areas/:area/zones/:zone/pickupdays
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-red/pickupdays',
    html => sub {
        my $content = shift;
        like $content, qr/2011-01-10/, 'html has a date';
    },
    text => sub {
        my $content = shift;
        like $content, qr/^2011-01-10 GR\n/, 'text has a date';
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is $data->[0]{day}, '2011-01-10', 'json has a day';
        like $data->[0]{zone_id}, qr/^\d+$/, 'json has a zone_id';
        is $data->[0]{flags}, 'GR', 'json has flags';
        is $data->[1]{flags}, 'GRYC', 'json has flags';
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
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-red/pickupdays.ics?t=123456789',
    ics => sub {
        my $ical = shift;
        my $entries = $ical->entries;
        is scalar(@$entries), 58;
    },
);

# GET /api/areas/:area/zones/:zone/nextpickup
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-purple/nextpickup',
    now => datetime(year => 2011, month => 1, day => 1),
    html => sub {
        my $content = shift;
        like $content, qr/2011-01-06/, 'html has a date';
        unlike $content, qr/2011-01-06 GRYC/, 'is not yard pickup';
    },
    text => sub {
        my $content = shift;
        is $content, "2011-01-06 GR", 'text is just the date';
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is scalar(@$data), 1, 'only one result';
        is $data->[0]{day}, '2011-01-06', 'date is correct';
    },
);

# GET /api/areas/:area/zones/:zone/nextpickup?limit=3
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-purple/nextpickup?limit=3',
    now => datetime(year => 2011, month => 1, day => 1),
    html => sub {
        my $content = shift;
        like $content, qr/2011-01-06/, 'html has a date';
        unlike $content, qr/2011-01-06 GRYC/, 'is not yard pickup';
        like $content, qr/2011-01-13 GRYC/, 'second date is a yard pickup';
        like $content, qr/2011-01-20/, 'third date is present';
        unlike $content, qr/2011-01-29/, 'fourth date is not present';
    },
    text => sub {
        my $content = shift;
        is $content, "2011-01-06 GR\n2011-01-13 GRYC\n2011-01-20 GR", 'text is just the date';
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'ARRAY';
        is scalar(@$data), 3, 'only one result';
        is $data->[0]{day}, '2011-01-06', 'date is correct';
        is $data->[1]{day}, '2011-01-13', 'date is correct';
        is $data->[2]{day}, '2011-01-20', 'date is correct';
    },
);

# GET /api/areas/:area/zones/:zone/nextdowchange
test_the_api_for(
    '/areas/Vancouver/zones/vancouver-north-purple/nextdowchange',
    now => datetime(year => 2011, month => 1, day => 11),
    html => sub {
        my $content = shift;
        unlike $content, qr/2011-01-13/, 'next pickup is not mentioned';
        unlike $content, qr/2011-01-20/, 'second date is not mentioned';
        like $content, qr/2011-05-02/, 'third date is mentioned as the last on the old sched';
    },
    text => sub {
        my $content = shift;
        is $content, "2011-05-02 GR", 'text is the date with flags';
    },
    json => sub {
        my $data = shift;
        return unless is ref($data), 'HASH';
        is $data->{last}{day}, '2011-04-21', 'date is correct';
        is $data->{next}{day}, '2011-05-02', 'date is correct';
    },
);

# GET /api/lookup/:lat,:lng(.+)
test_the_api_for(
    '/lookup/49.286283,-123.049622',
    raw => sub {
        my $resp = shift;
        is $resp->code, 302, 'we got a redirect';
        is $resp->header('Location'),
            '/api/areas/Vancouver/zones/vancouver-north-purple',
            'redirect is correct';
    },
);

# GET /api/lookup/:zone-name
test_the_api_for(
    '/lookup/vancouver-north-purple',
    raw => sub {
        my $resp = shift;
        is $resp->code, 302, 'we got a redirect';
        is $resp->header('Location'),
            '/api/areas/Vancouver/zones/vancouver-north-purple',
            'redirect is correct';
    },
);



done_testing();

exit;

sub test_the_post_api {
    my $uri     = shift;
    my $payload = shift;
    my $resp_cb = shift;
    my $app     = t::Recollect->app('Recollect::APIController');

    local $ENV{RECOLLECT_USER_IS_ADMIN} = 1;
    subtest "POST $uri" => sub {
        test_psgi $app, sub {
            my $cb = shift;

            my $res = $cb->(POST $uri,
                'Content-Type' => 'application/json',
                Content => encode_json $payload,
            );
            is $res->code, 201, "POST $uri returns 201";
            my $json = $res->content;
            my $data = eval { decode_json($json) };
            is $@, '', "json is valid";
            diag $json if $res->code == 500;
            $resp_cb->($data);
        };
    };
}

sub test_the_api_for {
    my $uri   = shift;
    my %tests = @_;
    local $ENV{RECOLLECT_NOW} = delete $tests{now};
    my $app = t::Recollect->app('Recollect::APIController');

    subtest "GET $uri" => sub {
        test_psgi $app, sub {
            my $cb = shift;

            my $test_uri = sub {
                my $uri        = shift;
                my $test_block = shift;
                my $res = $cb->(GET $uri);
                is $res->code, 200, "GET $uri returns 200";
                diag $res->content if $res->code != 200;
                $test_block->($res->content, @_);
            };
            if (my $test = $tests{html}) {
                $test_uri->($uri, sub {
                        my $content = shift;
                        like $content, qr/<body>/, 'html has a body tag';
                        $test->($content, @_);
                    },
                );
            }
            if (my $test = $tests{text}) {
                (my $txt_uri = $uri) =~ s/(\?(.+)$|$)/.txt$1/;
                $test_uri->($txt_uri, sub {
                        my $content = shift;
                        unlike $content, qr/<\w+.+?>/, 'text has no html tags';
                        $test->($content, @_);
                    },
                );
            }
            if (my $test = $tests{ics}) {
                $uri .= '.ics' unless $uri =~ m/\.ics/;
                $test_uri->($uri, sub {
                        my $text = shift;
                        my $ical = Data::ICal->new(data => $text);
                        $test->($ical);
                    },
                );
            }
            if (my $test = $tests{json}) {
                (my $json_uri = $uri) =~ s/(\?(.+)$|$)/.json$1/;
                $test_uri->(
                    $json_uri,
                    sub {
                        my $json = shift;
                        my $data = eval { decode_json($json) };
                        is $@, '', "json is valid";
                        $test->($data) unless $@;
                    }
                );
            }
            if (my $test = $tests{kml}) {
                (my $kml_uri = $uri) =~ s/(\?(.+)$|$)/.kml$1/;
                $test_uri->(
                    $kml_uri,
                    sub {
                        my $xml = shift;
                        die "No response body for $kml_uri" unless $xml;
                        my $data = XMLin($xml);
                        $test->($data);
                    }
                );
            }
            if (my $test = $tests{raw}) {
                my $res = $cb->(GET $uri);
                $test->($res);
            }
        };
    };
}

