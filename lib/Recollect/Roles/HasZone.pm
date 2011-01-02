package Recollect::Roles::HasZone;
use Moose::Role;
use Recollect::Zone;
use Carp 'croak';

requires 'zone_id';

sub By_zone_id {
    my $class   = shift;
    my $zone_id = shift;
    my %opts    = @_;

    my $p = $class->By_field(zone_id => $zone_id, %opts, all => 1);
    croak "Could not find any pickups for zone_id=$zone_id" unless @$p;
    return $p;
}

sub _build_zone {
    my $self = shift;
    return Recollect::Zone->By_id($self->zone_id);
}

1;
