#!perl
use Plack::Builder;
use Recollect::CallController;
use Recollect::Controller;
use Recollect::Config;

# Create the singleton config object
Recollect::Config->new(config_file => '/etc/recollect.yaml');

my $root = '/var/www/recollect';
my $log = '/var/log/recollect.log';
builder {
    enable "Plack::Middleware::AccessLog::Timed",
            format => "%h %l %u %t \"%r\" %>s %b %D";

    mount "/call" => sub { Recollect::CallController->new->run(@_) };
    mount "/api"  => sub { Recollect::APIController->new->run(@_) };
    mount "/"     => sub { Recollect::Controller->new->run(@_) }
};

