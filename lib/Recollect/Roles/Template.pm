package Recollect::Roles::Template;
use Moose::Role;
use Template;
use Recollect::Util qw/base_path/;

requires 'log';

has 'tt2' => (is => 'ro', isa => 'Object', lazy_build => 1);

sub _build_tt2 {
    my $self = shift;
    my $templ_path = base_path() . '/template';
    unless (-d $templ_path) {
        $self->log("Unknown template path: $templ_path from "
                . $self->request->path);
        return $self->not_found();
    }
    return Template->new(
        { INCLUDE_PATH => $templ_path },
    );
}

1;
