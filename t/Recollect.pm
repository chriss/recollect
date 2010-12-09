package t::Recollect;
use MooseX::Singleton;
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

BEGIN {
    $ENV{RECOLLECT_EMAIL} = "/tmp/email.$$";
    $ENV{RECOLLECT_DEV_ENV} = 1;

    use_ok 'Recollect::Model';
    use_ok 'Recollect::Log';
    $Recollect::Log::VERBOSE = 1;
}

END { 
    unlink $ENV{RECOLLECT_EMAIL} if $ENV{RECOLLECT_EMAIL};
    # Uncomment this for debugging
    # warn qx(cat $ENV{RECOLLECT_LOG_FILE}) if -e $ENV{RECOLLECT_LOG_FILE};
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
    copy "$FindBin::Bin/../data/trash-zone-times.yaml",
        "$tmp_dir/data/trash-zone-times.yaml";
    mkdir "$tmp_dir/etc";
    my $config = LoadFile("$FindBin::Bin/../etc/recollect.yaml.DEFAULT");
    $config->{db_name} = "recollect_$$";
    $config->{db_user} = $ENV{USER};
    my $test_config = "$tmp_dir/etc/recollect.yaml";
    DumpFile($test_config, $config);
    $ENV{RECOLLECT_TEST_CONFIG_FILE} = $test_config;

    $ENV{RECOLLECT_LOG_FILE} = "$tmp_dir/recollect.log";
    
    # Create the SQL db
    diag "createdb $config->{db_name}";
    system("createdb $config->{db_name}");

    my $sql_file = "$FindBin::Bin/../etc/sql/recollect.sql";
    if ($ENV{RECOLLECT_LOAD_DATA}) {
        $sql_file = "$FindBin::Bin/../etc/sql/recollect.dump";
    }
    diag "Loading schema from $sql_file";
    system("psql $config->{db_name} -f $sql_file > /dev/null 2>&1")
        and die "Couldn't psql $config->{db_name} -f $sql_file";
    return $tmp_dir;
}

sub app {
    local $ENV{RECOLLECT_LOAD_DATA} = 1;
    my $test_base = t::Recollect->base_path;
    Recollect::Config->new( config_file => "$test_base/etc/recollect.yaml");
    return sub {
        Recollect::Controller->new(
            base_path => $test_base,
            log_file  => "$test_base/recollect.log",
        )->run(@_);

    };
}

sub model {
    my $self = shift;
    my $test_base = t::Recollect->base_path;
    return Recollect::Model->new(
        base_path => $test_base,
        log_file  => "$test_base/recollect.log",
    );
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
