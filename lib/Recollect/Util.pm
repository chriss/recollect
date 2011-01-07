package Recollect::Util;
use strict;
use warnings;
use base 'Exporter';

our @EXPORT_OK = qw/base_path/;

sub base_path {
    $ENV{RECOLLECT_BASE_PATH} || '/var/www/recollect';
}

1;
