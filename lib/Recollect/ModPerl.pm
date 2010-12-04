package Recollect::ModPerl;
use Moose;
extends 'HTTP::Engine::Interface::ModPerl';
use Recollect::Controller;
use namespace::clean -except => 'meta';

sub create_engine {
    my($class, $r, $context_key) = @_;
    
    Recollect::Controller->new(
        http_module => 'ModPerl',
        base_path   => '/var/www/recollect',
    )->engine;
}

__PACKAGE__->meta->make_immutable;
1;
