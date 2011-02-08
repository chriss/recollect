package Recollect::Util;
use Moose;
extends 'Exporter';

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

our @EXPORT_OK = qw/base_path now tonight config log is_dev_env/;

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

sub is_dev_env { 
    return -e base_path() . "/app.psgi";
}

1;
