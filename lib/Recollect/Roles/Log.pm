package Recollect::Roles::Log;
use Moose::Role;
use Fatal qw/open close syswrite/;

our $VERBOSE = 0;

our $Log_file;

sub _build_log_file {
    return $ENV{RECOLLECT_LOG_FILE} if $ENV{RECOLLECT_LOG_FILE};
    my $real_log = '/var/log/recollect.log';
    return $real_log if -w $real_log;
    return 'recollect.log';
}

sub log {
    shift if $_[0] =~ m/::/;
    my $msg = localtime() . ": $_[0]\n";

    $Log_file ||= _build_log_file();
    open(my $fh, '>>', $Log_file);
    syswrite $fh, $msg;
    close $fh;
    warn $msg if $VERBOSE;
}

1;
