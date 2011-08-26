package Plack::Middleware::Recollect::JavaScript;
use Moose;
use methods;
use Recollect::JavaScript;
use namespace::clean -except => 'meta';

extends 'Plack::Middleware';

method call($env) {
    # Do something with $env
    if ($env->{PATH_INFO} =~ m{/compiled/([^/]+).(?:jgz|js)$}) {
        my $js = Recollect::JavaScript->new(target => $1);
        if ($js->needs_update) {
            warn "Building $env->{PATH_INFO}\n";
            $js->build;
        }
    }
    return $self->app->($env);
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
