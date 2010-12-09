package Recollect::Config;
use Moose::Role;
use YAML;
use namespace::clean -except => 'meta';

has '_config_file' => (is => 'ro', isa => 'Str',     lazy_build => 1);
has '_config_hash' => (is => 'rw', isa => 'HashRef', lazy_build => 1);
has '_config_timestamp'   => (is => 'rw', isa => 'Int', default => 0);

sub base_url {
    my $self = shift;
    return $self->_config_hash->{base_url} || 'http://recollect.net';
}

sub config {
    my $self = shift;

    # Reload if it changed
    if ($self->_config_timestamp > $self->_config_timestamp) {
        $self->_config_hash( $self->_load_config );
    }

    return $self->_config_hash;
}

sub _build__config_file {
    my $test_config = $ENV{RECOLLECT_TEST_CONFIG_FILE};
    return $test_config if $test_config and -e $test_config;

    my $dev_config = 'etc/recollect.yaml';
    return $dev_config if -e $dev_config;

    return '/etc/recollect.yaml';
}

sub _build__config_hash {
    my $self = shift;
    $self->_load_config;
}

sub _config_timestamp {
    my $self = shift;
    return (stat($self->_config_file))[9];
}

sub _load_config {
    my $self = shift;
    $self->_config_timestamp( $self->_config_timestamp );
    return YAML::LoadFile($self->_config_file);
}

1;
