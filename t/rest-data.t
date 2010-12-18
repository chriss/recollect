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

# GET /api/areas/:area              
#    * :area can be area_id or Vancouver or vancouver                                                                    
# GET /api/areas/:area/zones 
# GET /api/areas/:area/zones/:zone          
#    * should include pickupdays + nextpickup
# GET /api/areas/:area/zones/:zone/pickupdays +ics                                                            
# GET /api/areas/:area/zones/:zone/nextpickup                                                                
# GET /api/areas/:area/zones/:zone/nextdowchange  
# GET /api/areas/:area/zones/:lat,:lng(.+)

my $app = t::Recollect->app('Recollect::APIController');
test_html_txt_json('/version',
    html => sub {
        my $content = shift;
        like $content, qr/API Version/;
    },
    text => sub {
        my $content = shift;
        like $content, qr/^API Version: 1$/;
    },
    json => sub { # JSON tests
        my $data = shift;

        is $data->[0]{name}, 'API Version';
        is $data->[0]{value}, 1;
    },
);

my $vancouver_latlng = '49.26422,-123.138542';

test_html_txt_json('/areas',
    html => sub {
        my $content = shift;
        like $content, qr/Recollect Areas/;
        like $content, qr/Vancouver/;
    },
    text => sub {
        my $content = shift;
        is $content, "1 - Vancouver: $vancouver_latlng\n";
    },
    json => sub { # JSON tests
        my $data = shift;
        is ref($data), 'ARRAY';
        is scalar(@$data), 1;
        is $data->[0]{name}, 'Vancouver';
    },
);

Area_tests: {
    my %tests = (
        html => sub {
            my $content = shift;
            like $content, qr/Area - Vancouver/;
            like $content, qr/$vancouver_latlng/;
        },
        text => sub {
            my $content = shift;
            is $content, "id: 1\nname: Vancouver\ncentre: $vancouver_latlng\n";
        },
        json => sub { # JSON tests
            my $data = shift;
            is $data->{id}, 1;
            is $data->{name}, 'Vancouver';
            is $data->{centre}, $vancouver_latlng;
        },
    );
    test_html_txt_json('/areas/1', %tests);
    test_html_txt_json('/areas/Vancouver', %tests);
    test_html_txt_json('/areas/vancouver', %tests);
}

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
            $test->($data);
        }
    };
}


