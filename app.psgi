#!perl

# This is the development psgi file

use Plack::Builder;
use lib "lib";
use Recollect::CallController;
use Recollect::APIController;
use Recollect::Controller;

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

    my $set_env = sub { $ENV{RECOLLECT_BASE_PATH} = '.' };

    mount "/call" => sub { $set_env->(); Recollect::CallController->new->run(@_) };
    mount "/api"  => sub { $set_env->(); Recollect::APIController->new->run(@_) };
    mount "/"     => sub { $set_env->(); Recollect::Controller->new->run(@_) }
};

