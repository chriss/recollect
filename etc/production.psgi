#!perl
use Plack::Builder;
use Recollect::APIController;
use Recollect::CallController;
use Recollect::RadminController;
use Recollect::Controller;
use Recollect::Util;

my $config = Recollect::Util->config;

builder {
    enable "Plack::Middleware::AccessLog::Timed",
            format => "%h %l %u %t \"%r\" %>s %b %D";

    enable 'Session::Cookie';
    enable 'DoormanTwitter', root_url => $config->{base_url}, scope => 'radmin',
            consumer_key    => $config->{twitter_consumer_key},
            consumer_secret => $config->{twitter_consumer_secret};

    mount "/radmin" => sub { Recollect::RadminController->new->run(@_) };
    mount "/call"   => sub { Recollect::CallController->new->run(@_) };
    mount "/api"    => sub { Recollect::APIController->new->run(@_) };
    mount "/"       => sub { Recollect::Controller->new->run(@_) }
};

