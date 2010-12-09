package Recollect::Area;
use Moose;
use Recollect::Zone;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'     => (is => 'ro', isa => 'Int',              required   => 1);
has 'name'   => (is => 'ro', isa => 'Str',              required   => 1);
has 'centre' => (is => 'ro', isa => 'Str',              required   => 1);
has 'zones'  => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        map { $_ => $self->$_() } qw/id name centre/
    };
}

sub By_name {
    my $class = shift;
    my $sth = $class->By_field(name => shift);
    return $class->_first_row_as_obj($sth);
}

sub add_zone {
    my $self = shift;
    my %opts = @_;
    $opts{area_id} = $self->id;

    my $zone = Recollect::Zone->Create(%opts)
        or die "Could not create zone $opts{name}";
    delete $self->{zones};
}

sub _build_zones {
    my $self = shift;
    return Recollect::Zone->By_area_id($self->id);
}

__PACKAGE__->meta->make_immutable;
1;
