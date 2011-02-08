package Recollect::Collection;
use Moose;
use Carp qw/croak/;
use Data::UUID;
use namespace::clean -except => 'meta';

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

sub _select {
    my $self = shift;
    $self->execute('select', $self->db_table, @_);
}


sub All {
    my $class = shift;
    my $sth = $class->_select('*');
    return [ map { $class->new($_) } @{ $sth->fetchall_arrayref({}) } ];
}

sub Create {
    my $class = shift;
    my %args = @_;

    $args{id} ||= do { $class->_sequence_nextval };
    $class->insert($class->db_table, \%args);
    return $class->By_id($args{id});
}

sub Resolve {
    my $class = shift;
    my $id = shift;
    return $class->By_id($id) if $id =~ m/^\d+$/;;
    return $class->By_name($id);
}

sub By_id {
    my $class = shift;
    my $id = shift;
    my $obj = $class->By_field(id => $id);
    return $obj;
}

sub By_name {
    my $class = shift;
    die "$class has no name field!" unless $class->can('name');
    return $class->By_field('LOWER(name)' => lc shift);
}

# Examples
#   Straight lookup by id
#     $class->By_field( id => $id );
#   Lookup with additional where clauses
#     $class->By_field( this => $that, where => [ foo => 'bar' ] );
#     $class->By_field( this => $that, where => [ day => { '>', $time } ] );
#   Return results sorted
#     $class->By_field( this => $that, args => [ ['name ASC'] ] );
#   Return results sorted & limited
#     $class->By_field( this => $that, args => [ ['name ASC', $limit] ] );
sub By_field {
    my $class = shift;
    my $field = shift;
    my $value = shift;
    my %opts  = @_;
    
    my $sth = $class->_select('*', {
            $field => $value,
            @{ $opts{where} || [] },
        },
        @{ $opts{args} || [] },
    );
    return $sth if $opts{handle_pls};
    if ($opts{all}) {
        my @objs;
        while (my $row = $sth->fetchrow_hashref) {
            push @objs, $class->new($row);
        }
        return \@objs;
    }
    return $class->_first_row_as_obj($sth);
}

sub delete {
    my $self = shift;

    my ($stmt, @bind) = $self->_sql->delete($self->db_table, { id => $self->id });
    $self->run_sql($stmt, \@bind);
}

sub _first_row_as_obj {
    my $self_or_class = shift;
    my $class = ref($self_or_class) || $self_or_class;
    my $sth = shift;
    my $row = $sth->fetchrow_hashref;
    return $row ? $class->new($row) : undef;
}

sub _sequence_nextval {
    my $class = shift;
    return $class->nextval($class->db_table);
}

sub db_table {
    my $class = ref($_[0]) ? ref($_[0]) : $_[0];
    (my $table = $class) =~ s/^.+::(.+)$/lc($1) . 's'/e;
    return $table;
}

sub _build_uuid { Data::UUID->new->create_str }

__PACKAGE__->meta->make_immutable;
1;
