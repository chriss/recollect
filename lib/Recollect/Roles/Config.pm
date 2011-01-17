package Recollect::Roles::Config;
use Moose::Role;
use YAML;
use namespace::clean -except => 'meta';

our $CONFIG;
our $LAST_MODIFIED;

sub base_url {
    my $self = shift;
    return $self->config->{base_url} || 'http://recollect.net';
}

around [qw/base_url config/] => sub {
    my $orig = shift;

    $LAST_MODIFIED ||= _config_last_modified();
    if ($LAST_MODIFIED < _config_last_modified()) {
        $CONFIG = _load_config();
        $LAST_MODIFIED = _config_last_modified();
    }

    $orig->(@_);
};

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

sub _config_last_modified { (stat(_config_filename()))[9] }

sub _build__config_hash { shift->_load_config }

sub _load_config {
    return YAML::LoadFile(_config_filename());
}

1;
