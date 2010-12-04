package Recollect::Pickups;
use Moose;
use DateTime;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

sub by_zone {
    my $self = shift;
    my $zone = shift;
    my $obj_please = shift;
    return [
        map { $obj_please ? $_ : $_->to_hash } $self->_rs->search(
                { zone     => $zone },
                { order_by => { -asc => 'day' } },
            )->all
    ];
}

sub by_epoch {
    my $self = shift;
    my $zone = shift;
    my $epoch  = shift;

    my $dt = DateTime->from_epoch(epoch => $epoch);
    my $day = $dt->ymd;
    return $self->_rs->search( { zone => $zone, day => $day } )->first;
}

__PACKAGE__->meta->make_immutable;
1;
