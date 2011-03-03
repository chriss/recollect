package t::Recollect;
use MooseX::Singleton;
use Plack::Builder;
use File::Temp qw/tempdir/;
use File::Copy qw/copy/;
use File::Slurp;
use FindBin;
use Fatal qw/mkdir symlink copy/;
use Test::More;
use File::Slurp;
use YAML qw/LoadFile DumpFile/;
use mocked 'Net::Twitter';
use mocked 'Net::Recurly';
use mocked 'WWW::Twilio::API';
use mocked 'Business::PayPal::NVP';
use mocked 'Business::PayPal::IPN';
use mocked 'LWP::UserAgent';

use lib 'lib';
use SQL::PgSchema;
use namespace::clean -except => 'meta';

our $DEBUG;
my $config = LoadFile("$FindBin::Bin/../etc/recollect.yaml.DEFAULT");

BEGIN {
    $DEBUG = 0;
    $ENV{RECOLLECT_EMAIL} = "/tmp/email.$$";
    $ENV{RECOLLECT_BASE_PATH} = '.';

    use_ok 'Recollect::Roles::Log';
    use_ok 'Recollect::Roles::SQL';
    $Recollect::Roles::SQL::DEBUG = $Recollect::Roles::Log::VERBOSE = $DEBUG;
}

END { 
    unlink $ENV{RECOLLECT_EMAIL} if $ENV{RECOLLECT_EMAIL};
    if ($ENV{RECOLLECT_EMPTY_DB_PLS}) {
        my $dbh = $Recollect::Roles::SQL::DBH;
        $dbh->disconnect if $dbh;
        system("dropdb $config->{db_name}");
    }
}

has 'base_path' => (is => 'ro', lazy_build => 1);

my @http_requests;
{
    no warnings 'redefine';
    *Recollect::Notifier::http_post = sub { push @http_requests, \@_ };
}

sub setup_env {
    shift->base_path;
    return 1;
}

sub _build_base_path {
    my $self = shift;

    my $tmp_dir = tempdir( CLEANUP => 1 );
    mkdir "$tmp_dir/data";
    symlink "$FindBin::Bin/../template", "$tmp_dir/template";
    symlink "$FindBin::Bin/../root", "$tmp_dir/root";
    mkdir "$tmp_dir/etc";
    my $user = $ENV{USER} eq 'ubuntu' ? '' : $ENV{USER};
    $config->{db_name} = "recollect_${user}_test";
    $config->{db_user} = $ENV{USER};
    my $test_config = "$tmp_dir/etc/recollect.yaml";
    $ENV{RECOLLECT_TEST_CONFIG_FILE} = $test_config;

    $ENV{RECOLLECT_LOG_FILE} = "$tmp_dir/recollect.log";
    
    # Create the SQL db
    my $db_name = $config->{db_name};
    my $sql_file = "$FindBin::Bin/../etc/sql/recollect.sql";
    if ($ENV{RECOLLECT_EMPTY_DB_PLS}) {
        $db_name .= "-$$";
        $config->{db_name} = $db_name;
    }
    $Recollect::Roles::SQL::DBH = undef; # force it to reload
    DumpFile($test_config, $config);
    my $psql = "psql $db_name";

    warn "Testing with db $db_name" if $DEBUG;
    if (system("createdb $db_name 2> /dev/null") == 0) {
        diag "created database $db_name, loading $sql_file" if $DEBUG;
        _setup_postgis($db_name);

        system("sudo -u postgres $psql -f $sql_file > /dev/null")
            and die "Couldn't psql $db_name -f $sql_file";
        if (!$ENV{RECOLLECT_EMPTY_DB_PLS}) {
            $sql_file = "$FindBin::Bin/../etc/sql/vancouver.sql";
            system("$psql -f $sql_file > /dev/null")
                and die "Couldn't psql $db_name -f $sql_file";
        }
    }
    SQL::PgSchema->new(
        psql => $psql,
        schema_name => 'recollect',
        schema_dir => "etc/sql",
        debug => 1,
    )->update;
    system(qq{$psql -c "DELETE FROM areas WHERE name != 'Vancouver' " });
    system(qq{$psql -c 'DELETE FROM reminders' > /dev/null});
    system(qq{$psql -c 'DELETE FROM subscriptions' > /dev/null});
    system(qq{$psql -c 'DELETE FROM users' > /dev/null});
    return $tmp_dir;
}

sub _setup_postgis {
    my $db_name = shift;

    system(qq{sudo -u postgres psql $db_name -c "CREATE LANGUAGE 'plpgsql'"})
        and die "Couldn't psql $db_name -c create language plpgsql";
    my @postgises = (
        '/usr/share/postgresql/8.4/contrib/postgis-1.5/postgis.sql',
        '/usr/share/postgresql/8.4/contrib/postgis.sql',
    );
    for my $p (@postgises) {
        next unless -e $p;
        my $cmd = "sudo -u postgres psql $db_name -f $p > /dev/null";
        system($cmd) and die "Couldn't $cmd";
    }
}

sub app {
    my $class = shift;
    my $controller = shift or die "Requires a controller";
    my $base = t::Recollect->base_path;
    my $now = $ENV{RECOLLECT_NOW};
    my $test_base = t::Recollect->base_path;
    $ENV{RECOLLECT_LOG_FILE} = "$test_base/recollect.log",
    return sub { 
        local $ENV{RECOLLECT_BASE_PATH}        = $base;
        local $ENV{RECOLLECT_TEST_CONFIG_FILE} = "$base/etc/recollect.yaml";
        local $ENV{RECOLLECT_LOG_FILE}         = "$base/recollect.log";
        local $ENV{RECOLLECT_NOW}              = $now if $now;
        $controller->new->run(@_) 
    };
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

sub log_like {
    my @tests;
    if (@_ == 1) {
        @tests = @{ $_[0] };
    }
    else {
        @tests = (@_);
    }
    
    my $contents = read_file($ENV{RECOLLECT_LOG_FILE}) || 'Log file was empty';
    for my $t (@tests) {
        my $match = shift @tests;
        my $desc = shift(@tests) || 'log_like';
        like $contents, $match, $desc;
    }
    unlink $ENV{RECOLLECT_LOG_FILE};
}



__PACKAGE__->meta->make_immutable;
1;
