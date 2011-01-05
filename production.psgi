#!perl
use Plack::Builder;
use Recollect::CallController;
use Recollect::Controller;

builder {
    enable "Plack::Middleware::AccessLog::Timed",
            format => "%h %l %u %t \"%r\" %>s %b %D";

    mount "/call" => sub { Recollect::CallController->new->run(@_) };
    mount "/api"  => sub { Recollect::APIController->new->run(@_) };
    mount "/"     => sub { Recollect::Controller->new->run(@_) }
};

