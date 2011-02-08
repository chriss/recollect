package Recollect::Roles::SQL;
use Moose::Role;
use DateTime::Format::Pg;
use DBI;
use Carp qw/croak/;
use SQL::Abstract::Limit;

requires 'config';

has 'dsn'  => (is => 'rw', isa => 'Str',    lazy_build => 1);

our $DEBUG = 0;
our $DBH;
our $SQL = SQL::Abstract::Limit->new(limit_dialect => 'LimitOffset');
sub _sql { $SQL }
sub dbh { $DBH }

before [qw/dbh execute insert nextval run_sql/] =>
    sub { $DBH ||= shift->_connect_dbh };

sub execute {
    my $self = shift;
    my $func = shift;

    my ($stmt, @bind) = $SQL->$func(@_);
    return $self->run_sql($stmt, \@bind);
}

sub run_sql {
    my $self = shift;
    my $stmt = shift;
    my $bind = shift || [];

    if ($DEBUG) {
        warn "About to execute:\n" . $stmt . "\nWith (@$bind)\n";
    }
    
    my $sth = $DBH->prepare($stmt);
    die "Could not prepare query: " .$sth->errstr if $sth->err;
    $sth->execute(@$bind);
    die "Could not execute query: " .$sth->errstr if $sth->err;
    return $sth;
}

sub insert {
    my $self = shift;
    my ($stmt, @bind) = $SQL->insert(@_);
    my $sth = $DBH->prepare($stmt) or croak "SQL error ($stmt): ".$DBH->errstr;
    $sth->execute(@bind)           or croak "SQL error ($stmt): ".$DBH->errstr;
}

sub sql_singlevalue {
    my $self = shift;
    my $sth = $self->run_sql(@_);
    my $value;
    $sth->bind_columns(undef, \$value);
    $sth->fetch;
    $sth->finish;
    $value =~ s/\s+$// if defined $value;
    return $value;
}

sub nextval {
    my $self = shift;
    my $table = shift;
    (my $seq = $table) =~ s/^(.+)s$/${1}_seq/;
    my $sth = $DBH->prepare("SELECT nextval('$seq')");
    $sth->execute;
    my $row = $sth->fetchrow_arrayref;
    return $row->[0];
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
    croak "Could not connect to database with dsn: $dsn: $!\n" unless $dbh;
    return $dbh;
}

1;
