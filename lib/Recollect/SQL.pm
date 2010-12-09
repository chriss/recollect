package Recollect::SQL;
use MooseX::Singleton;
use DateTime::Format::Pg;
use DBI;
use Carp qw/croak/;
use SQL::Abstract;
use namespace::clean -except => 'meta';

with 'Recollect::Config';

has 'dsn'  => (is => 'rw', isa => 'Str',    lazy_build => 1);
has 'dbh'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has '_sql' => (is => 'ro', isa => 'Object', lazy_build => 1);

our $DEBUG = 0;

sub execute {
    my $self = shift;
    my $func = shift;

    my ($stmt, @bind) = $self->_sql->$func(@_);
    if ($DEBUG) {
        warn "About to execute:\n" . $stmt . "\nWith (@bind)\n";
    }
    my $sth = $self->dbh->prepare($stmt);
    $sth->execute(@bind);
    return $sth;
}

sub insert {
    my $self = shift;
    my $dbh  = $self->dbh;
    my ($stmt, @bind) = $self->_sql->insert(@_);
    my $sth = $dbh->prepare($stmt) or die $dbh->errstr;
    $sth->execute(@bind)           or die $dbh->errstr;
}

sub nextval {
    my $self = shift;
    my $table = shift;
    (my $seq = $table) =~ s/^(.+)s$/${1}_seq/;
    my $sth = $self->dbh->prepare("SELECT nextval('$seq')");
    $sth->execute;
    my $row = $sth->fetchrow_arrayref;
    return $row->[0];
}

sub _build__sql { SQL::Abstract->new }

sub _build_dbh {
    my $self = shift;

    my $dbh = eval { $self->_connect_dbh() };
    my $err = $@;
    croak $err if $@;
    return $dbh;
}

sub _connect_dbh {
    my $self = shift;
    my %params = (
        db_name => $self->config->{db_name}
                        || die "db_name must be defined in the config",
        db_user => $self->config->{db_user}
                        || die "db_user must be defined in the config",
    );
    my $dsn = "dbi:Pg:database=$params{db_name}";
    my $dbh = DBI->connect($dsn, $params{db_user}, "",  {
        AutoCommit => 1,
        pg_enable_utf8 => 1,
        PrintError => 0,
        RaiseError => 0,
    });
    die "Could not connect to database with dsn: $dsn: $!\n" unless $dbh;
    return $dbh;
}

1;
