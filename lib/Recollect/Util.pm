package Recollect::Util;
use Moose;
extends 'Exporter';

with 'Recollect::Roles::Config';

our @EXPORT_OK = qw/base_path now tonight/;

sub base_path { $ENV{RECOLLECT_BASE_PATH} || '/var/www/recollect' }

sub now {
    return $ENV{RECOLLECT_NOW} if $ENV{RECOLLECT_NOW};
    my $dt = DateTime->now;
    $dt->set_time_zone('America/Vancouver');
    return $dt;
}

sub tonight {
    my $now = now();
    $now->set( hour => 23, minute => 59 );
    return $now;
}

1;
