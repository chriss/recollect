#!perl

# This is the development psgi file

use Plack::Builder;
use lib "lib";
use Recollect::RadminController;
use Recollect::CallController;
use Recollect::APIController;
use Recollect::Controller;
use SQL::PgSchema;

use Recollect::Roles::Cacheable;
Recollect::Roles::Cacheable->cache; # create the cache in the main process

use Recollect::Util;
my $config = Recollect::Util->config;

use FindBin;
SQL::PgSchema->new(
    psql => "psql $config->{db_name}",
    schema_name => "recollect",
    schema_dir => "$ENV{HOME}/src/recollect/etc/sql",
    debug => 1,
)->update;


builder {
    enable 'Debug', panels => [qw(
        Environment Response Memory Timer 
        Parameters Session
    )];
    enable 'Debug::DBIProfile', profile => 2;
    enable 'Debug::DBITrace';

    enable "Plack::Middleware::Static",
           path => qr{^/(robots\.txt|kml/.+|favicon.ico)},
           root => './root/';
    enable "Plack::Middleware::Static",
           path => sub { s!^/(?:\d+\.\d+\.\d+)/(images|javascript|css|audio)/(.+)!/$1/$2! },
           root => './root/';

    my $set_env = sub { $ENV{RECOLLECT_BASE_PATH} = "$ENV{HOME}/src/recollect" };

    enable 'Session::Cookie';
    enable 'DoormanTwitter', root_url => $config->{base_url}, scope => 'radmin',
            consumer_key => $config->{twitter_consumer_key},
            consumer_secret => $config->{twitter_consumer_secret};

    mount "/call"   => sub { $set_env->(); Recollect::CallController->new->run(@_) };
    mount "/api"    => sub { $set_env->(); Recollect::APIController->new->run(@_) };
    mount "/radmin" => sub { $set_env->(); Recollect::RadminController->new->run(@_) };
    mount "/"       => sub { $set_env->(); Recollect::Controller->new->run(@_) }
};

