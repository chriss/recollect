package Recollect::Collection;
use Moose;
use Carp qw/croak/;
use Recollect::SQL;
use namespace::clean -except => 'meta';

sub _sql { Recollect::SQL->new }
sub _select { _sql()->execute('select', shift->db_table, @_) }

sub All {
    my $class = shift;
    my $sth = $class->_select('*');
    return [ map { $class->new($_) } @{ $sth->fetchall_arrayref({}) } ];
}

sub Create {
    my $class = shift;
    my %args = @_;

    $args{id} ||= do { $class->_sequence_nextval };
    _sql()->insert($class->db_table, \%args);
    return $class->By_id($args{id});
}

sub By_id {
    my $class = shift;
    my $id = shift;
    my $sth = $class->By_field(id => $id);
    my $obj = $class->_first_row_as_obj($sth);
    die "Could not lookup $class id $id" unless $obj;
    return $obj;
}

sub By_name {
    my $class = shift;
    die "$class has no name field!" unless $class->can('name');
    my $sth = $class->By_field(name => shift);
    return $class->_first_row_as_obj($sth);
}

sub By_field {
    my $class = shift;
    my $field = shift;
    my $value = shift;
    my %opts  = @_;
    
    return $class->_select('*', {
            $field => $value,
            @{ $opts{where} || [] },
        },
        @{ $opts{args} || [] },
    );
}

sub _first_row_as_obj {
    my $class = shift;
    my $sth = shift;
    my $row = $sth->fetchrow_hashref;
    return $row ? $class->new($row) : undef;
}

sub _sequence_nextval {
    my $class = shift;
    return _sql()->nextval($class->db_table);
}

sub db_table {
    my $class = ref($_[0]) ? ref($_[0]) : $_[0];
    (my $table = $class) =~ s/^.+::(.+)$/lc($1) . 's'/e;
    return $table;
}


__PACKAGE__->meta->make_immutable;
1;
