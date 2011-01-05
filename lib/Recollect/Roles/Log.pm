package Recollect::Roles::Log;
use Moose::Role;
use Fatal qw/open close syswrite/;

our $VERBOSE = 0;

has 'log_file'    => (is => 'rw', isa => 'Str', lazy_build => 1);

sub _build_log_file {
    return $ENV{RECOLLECT_LOG_FILE} if $ENV{RECOLLECT_LOG_FILE};
    my $real_log = '/var/log/recollect.log';
    return $real_log if -w $real_log;
    return 'recollect.log';
}

sub log {
    my $self = shift;
    my $msg = localtime() . ": $_[0]\n";
    open(my $fh, '>>', $self->log_file);
    syswrite $fh, $msg;
    close $fh;
    warn $msg if $VERBOSE;
}

1;
