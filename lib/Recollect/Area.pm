package Recollect::Area;
use Moose;
use Recollect::Zone;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'     => (is => 'ro', isa => 'Int',              required   => 1);
has 'name'   => (is => 'ro', isa => 'Str',              required   => 1);
has 'centre' => (is => 'ro', isa => 'Str',              required   => 1);

has 'uri'   => (is => 'ro', isa => 'Str',              lazy_build => 1);
has 'zones' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);

sub to_hash {
    my $self = shift;
    return {
        map { $_ => $self->$_() } qw/id name centre/
    };
}

sub resolve_zone_id {
    my $self    = shift;
    my $zone_id = shift;
    my $sth;
    if ($zone_id =~ m/^\d+$/) {
        return Recollect::Zone->By_field(
            id    => $zone_id,
            where => [ area_id => $self->id ],
        );
    }
    return Recollect::Zone->By_field(
        name  => $zone_id,
        where => [ area_id => $self->id ],
    );
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

sub _build_uri {
    my $self = shift;
    return "/api/areas/" . $self->id;
}

__PACKAGE__->meta->make_immutable;
1;