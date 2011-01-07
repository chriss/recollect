package Recollect::Template;
use Moose;
use Template;
use Recollect::Util qw/base_path/;
use namespace::clean -except => 'meta';

has '_template' => (is => 'ro', isa => 'Object', lazy_build => 1,
                    handles => [ qw/process error/ ]);

sub _build__template {
    my $self = shift;
    my $templ_path = base_path() . '/template';
    unless (-d $templ_path) {
        die "No such template path! $templ_path";
    }
    return Template->new(
        { INCLUDE_PATH => $templ_path },
    );
}

__PACKAGE__->meta->make_immutable;
1;
