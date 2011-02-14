package Recollect::Roles::Template;
use Moose::Role;
use Template;
use Recollect::Util;
use namespace::clean -except => 'meta';

requires 'log';

sub base_path { 
    my $class = shift;
    Recollect::Util::base_path(@_);
}

our $TT2;
sub tt2 { $TT2 ||= shift->_build_tt2 }

sub _build_tt2 {
    my $class = shift;
    my $templ_path = $class->base_path() . '/template';
    return Template->new(
        { INCLUDE_PATH => $templ_path },
    );
}

1;
