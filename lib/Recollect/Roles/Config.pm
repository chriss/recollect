package Recollect::Roles::Config;
use Moose::Role;
use YAML;
use namespace::clean -except => 'meta';

our $CONFIG;

sub base_url {
    my $self = shift;
    return $self->config->{base_url} || 'http://recollect.net';
}

sub config {
    my $self = shift;

    return $CONFIG ||= _load_config();
}

sub _config_filename {
    if (my $test = $ENV{RECOLLECT_TEST_CONFIG_FILE}) {
        return $test if -e $test;
    }

    my $dev_config = 'etc/recollect.yaml';
    return $dev_config if -e $dev_config;

    return '/etc/recollect.yaml';
}

sub _build__config_hash {
    my $self = shift;
    $self->_load_config;
}

sub _load_config {
    return YAML::LoadFile(_config_filename());
}

1;
