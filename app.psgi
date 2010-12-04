#!perl

# This is the development psgi file

use Plack::Builder;
use lib "lib";
use Recollect::CallController;
use Recollect::Controller;
use Recollect::Config;

Recollect::Config->new(config_file => 'etc/recollect.yaml');

builder {
    enable 'Debug', panels => [qw(
        Environment Response Memory Timer 
        Parameters Session
    )];
    enable 'Debug::DBIProfile', profile => 2;
    enable 'Debug::DBITrace';

    enable "Plack::Middleware::Static",
           path => qr{^/(robots\.txt|zones\.kml|images)}, 
           root => './static/';
    enable "Plack::Middleware::Static",
           path => sub { s!^/(javascript|css)/(?:\d+\.\d+)/(.+)!/$1/$2! },
           root => './static/';

    mount "/call" => sub {
        Recollect::CallController->new(
            base_path => ".",
            log_file => 'recollect.log',
        )->run(@_);
    };

    mount "/" => sub {
        local $ENV{RECOLLECT_DEV_ENV} = 1;
        Recollect::Controller->new(
            base_path => ".",
            log_file => 'recollect.log',
        )->run(@_);
    }
};

