package SQL::PgSchema;
use Moose;
use List::Util qw/max first/;
use IPC::Run3;

has 'psql'        => (isa => 'Str',  is => 'ro', required => 1);
has 'schema_name' => (isa => 'Str',  is => 'ro', required => 1);
has 'schema_dir'  => (isa => 'Str',  is => 'ro', required => 1);
has 'debug'       => (isa => 'Bool', is => 'ro', default => sub { 0 });

has 'table'   => (isa => 'Str',               is => 'ro', lazy_build => 1);
has 'patches' => (isa => 'ArrayRef[HashRef]', is => 'ro', lazy_build => 1);

sub update {
    my $self = shift;

    my $latest_version = $self->latest_version;
    my $cur_ver = $self->current_version;
    warn "Current schema version is: $cur_ver. Latest is $latest_version\n"
        if $self->debug;
    if ($latest_version == $cur_ver) {
        warn "Schema is up to date!\n" if $self->debug;
        return;
    }

    for my $p (sort { $a->{from} <=> $b->{from} } @{ $self->patches }) {
        next unless $p->{from} == $cur_ver;

        print "Running $p->{file} ...\n";
        run3 $self->psql . " -f $p->{file}", undef, $self->debug ? undef : '/dev/null';

        $cur_ver = $self->current_version;
        die "Error! schema should be at $p->{to} but is only at $cur_ver!"
            if $p->{to} != $cur_ver;
    }
}

sub current_version {
    my $self = shift;
    my $psql = $self->psql;
    my $table = $self->table;

    my $version;
    my $stderr;
    warn "Checking current_version from $table using $psql\n" if $self->debug;
    run3 $psql . qq{ -qt -c "SELECT current_version FROM $table"},
        undef, \$version, \$stderr;
    # warn "stdout=($version) stderr=($stderr)";
    chomp $version;
    chomp $version;
    if ($stderr =~ m/relation "\Q$table\E" does not exist/) {
        $self->create_version_table;
        return $self->current_version;
    }

    return $version || 0;
}

sub latest_version {
    my $self = shift;
    
    return max(map { $_->{to} } @{$self->patches}) || 0;
}

sub create_version_table {
    my $self = shift;
    my $psql = $self->psql;
    my $table = $self->schema_name . '_schema';

    my $sql = qq{CREATE TABLE $table (}
            . qq{current_version text NOT NULL, }
            . qq{updated_time timestamptz DEFAULT 'now'::timestamptz NOT NULL}
            . qq{);};
    my $output = qx($psql -c "$sql" 2>&1);
    warn $output;
}

sub _build_table { shift->schema_name . '_schema' }

sub _build_patches {
    my $self = shift;

    return [
        grep { defined $_->{from} and $_->{to} }
            map {
                $_ =~ m/-(\d+)-to-(\d+)\.sql$/;
                { file => $_, from => $1, to => $2 }
            } glob $self->schema_dir . '/' . $self->schema_name . '-*-to-*.sql'
    ];
}

1;
