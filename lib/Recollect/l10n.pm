package Recollect::l10n;
use strict;
use warnings;
use Recollect::Util qw/base_path/;
use base 'Exporter';

our @EXPORT_OK = qw/loc loc_lang/;

my $l10n_path = base_path() . "/l10n";
require Locale::Maketext::Simple;
Locale::Maketext::Simple->import(
    Path => $l10n_path,
    Decode => 1,
    Export => '_loc',
);

# We may need to do hacks here
sub loc {
    my $msg = shift;
    return _loc($msg, @_);
}

sub loc_lang { _loc_lang(@_) }

1;
