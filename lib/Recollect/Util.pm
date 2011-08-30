package Recollect::Util;
use Moose;
extends 'Exporter';

our @EXPORT_OK = qw/base_path now tonight config log is_dev_env is_live/;

sub base_path { $ENV{RECOLLECT_BASE_PATH} || '/var/www/recollect' }

# Does-it-all util class so you can use some of the roles
# without having an object.
with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Template';
with 'Recollect::Roles::Email';

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

sub is_live { !is_dev_env() }

1;
