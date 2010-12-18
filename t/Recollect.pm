package t::Recollect;
use MooseX::Singleton;
use Plack::Builder;
use File::Temp qw/tempdir/;
use File::Copy qw/copy/;
use FindBin;
use Fatal qw/mkdir symlink copy/;
use Test::More;
use File::Slurp;
use YAML qw/LoadFile DumpFile/;
use mocked 'Net::Twitter';
use mocked 'WWW::Twilio::API';
use mocked 'Business::PayPal::NVP';
use mocked 'Business::PayPal::IPN';

use lib 'lib';
use namespace::clean -except => 'meta';

my $config = LoadFile("$FindBin::Bin/../etc/recollect.yaml.DEFAULT");

BEGIN {
    $ENV{RECOLLECT_EMAIL} = "/tmp/email.$$";

    use_ok 'Recollect::Model';
    use_ok 'Recollect::Log';
    use_ok 'Recollect::SQL';
    $Recollect::SQL::DEBUG = $Recollect::Log::VERBOSE = 1;
}

END { 
    unlink $ENV{RECOLLECT_EMAIL} if $ENV{RECOLLECT_EMAIL};
    if ($ENV{RECOLLECT_EMPTY_DB_PLS}) {
        system("dropdb $config->{db_name} 2> /dev/null");
    }
}

has 'base_path' => (is => 'ro', lazy_build => 1);

my @http_requests;
{
    no warnings 'redefine';
    *Recollect::Notifier::http_post = sub { push @http_requests, \@_ };
}

sub _build_base_path {
    my $self = shift;

    my $tmp_dir = tempdir( CLEANUP => 0 );
    mkdir "$tmp_dir/data";
    symlink "$FindBin::Bin/../template", "$tmp_dir/template";
    mkdir "$tmp_dir/etc";
    my $user = $ENV{USER} eq 'ubuntu' ? '' : $ENV{USER};
    $config->{db_name} = "recollect_${user}_test";
    $config->{db_user} = $ENV{USER};
    my $test_config = "$tmp_dir/etc/recollect.yaml";
    DumpFile($test_config, $config);
    $ENV{RECOLLECT_TEST_CONFIG_FILE} = $test_config;

    $ENV{RECOLLECT_LOG_FILE} = "$tmp_dir/recollect.log";
    
    # Create the SQL db
    my $psql = "psql $config->{db_name}";
    my $sql_file = "$FindBin::Bin/../data/recollect.dump";
    if ($ENV{RECOLLECT_EMPTY_DB_PLS}) {
        $config->{db_name} .= "-$$";
        $sql_file = "$FindBin::Bin/../etc/sql/recollect.sql";
    }
    if (system("createdb $config->{db_name} 2> /dev/null") == 0) {
        diag "created database $config->{db_name}, loading $sql_file";
        system("$psql -f $sql_file > /dev/null 2>&1")
            and die "Couldn't psql $config->{db_name} -f $sql_file";
    }
    system(qq{$psql -c 'DELETE FROM users'});
    system(qq{$psql -c 'DELETE FROM reminders'});
    system(qq{$psql -c 'DELETE FROM subscriptions'});
    return $tmp_dir;
}

sub app {
    my $class = shift;
    my $controller = shift or die "Requires a controller";
    my $base = t::Recollect->base_path;
    return sub { 
        local $ENV{RECOLLECT_BASE_PATH}        = $base;
        local $ENV{RECOLLECT_TEST_CONFIG_FILE} = "$base/etc/recollect.yaml";
        local $ENV{RECOLLECT_LOG_FILE}         = "$base/recollect.log";
        $controller->new->run(@_) 
    };
}

sub model {
    my $self = shift;
    my $test_base = t::Recollect->base_path;
    $ENV{RECOLLECT_LOG_FILE} = "$test_base/recollect.log",
    return Recollect::Model->new( base_path => $test_base );
}

sub email_content {
    return eval { scalar read_file($ENV{RECOLLECT_EMAIL}) } || '';
}

sub clear_email {
    unlink $ENV{RECOLLECT_EMAIL};
}

sub clear_twitters {
    @Net::Twitter::MESSAGES = ();
}

sub twitters {
    return [ @Net::Twitter::MESSAGES ];
}

sub http_requests {
    return [ @http_requests ];
}

sub set_time {
    my $self = shift;
    my $dt   = shift;

    no warnings 'redefine';
    *Recollect::Notifier::now = sub { $dt->epoch };
}

__PACKAGE__->meta->make_immutable;
1;
