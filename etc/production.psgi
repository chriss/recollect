#!perl
use Plack::Builder;
use Recollect::APIController;
use Recollect::CallController;
use Recollect::RadminController;
use Recollect::AdminController;
use Recollect::Controller;

use Recollect::Roles::Cacheable;
Recollect::Roles::Cacheable->cache; # create the cache in the main process

use Recollect::Util qw/base_path/;
my $config = Recollect::Util->config;

builder {
    enable "Plack::Middleware::AccessLog::Timed",
            format => "%h %l %u %t \"%r\" %>s %b %D";

    enable "ConditionalGET";
    enable 'Session::Cookie', secret => $config->{session_secret} || die;

    enable 'DoormanAuthentication', scope => 'admin',
        authenticator => \&Recollect::AdminController::Authenticator;
    enable 'DoormanTwitter', scope => 'radmin',
        root_url => $config->{base_url},
        consumer_key    => $config->{twitter_consumer_key},
        consumer_secret => $config->{twitter_consumer_secret};

    mount "/admin"  => sub { Recollect::AdminController->new->run(@_) };
    mount "/radmin" => sub { Recollect::RadminController->new->run(@_) };
    mount "/call"   => sub { Recollect::CallController->new->run(@_) };
    mount "/api"    => sub { Recollect::APIController->new->run(@_) };
    mount "/"       => sub { Recollect::Controller->new->run(@_) }
};

