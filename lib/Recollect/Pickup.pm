package Recollect::Pickup;
use feature 'switch';
use Moose;
use DateTime::Functions;
use DateTime::Format::Pg;
use Carp qw/croak/;
use namespace::clean -except => 'meta';

has 'id'         => (is => 'ro', isa => 'Int',      required   => 1);
has 'zone_id'    => (is => 'ro', isa => 'Int',      required   => 1);
has 'day'        => (is => 'ro', isa => 'Str',      required   => 1);
has 'flags'      => (is => 'ro', isa => 'Str',      required   => 1);

has 'zone'       => (is => 'ro', isa => 'Object',   lazy_build => 1);
has 'string'     => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'pretty_day' => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'desc'       => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'datetime'   => (is => 'ro', isa => 'DateTime', lazy_build => 1,
                     handles => ['ymd', 'day_of_week']);

extends 'Recollect::Collection';
with 'Recollect::Roles::HasZone';
with 'Recollect::Roles::Cacheable';

sub By_zone_id {
    Recollect::Roles::HasZone::By_zone_id(@_, args => [ ['day ASC'] ]);
}

sub to_hash {
    my $self = shift;
    return {
        day => $self->ymd,
        zone_id => $self->zone_id,
        flags => $self->flags,
    };
}

sub _build_string {
    my $self = shift;
    return join ' ', $self->ymd, ($self->flags ? $self->flags : ());
}

sub _build_pretty_day {
    my $self = shift;
    my $dt = $self->datetime;
    return $dt->day_name . ', ' . $dt->month_name . ' ' . $dt->day;
}

sub _build_desc {
    my $self = shift;
    given ($self->flags) {
        when (m/Y/) { return "Garbage & Yard Trimmings Pickup" }
        default     { return "Garbage Pickup" }
    }
}

sub _build_datetime {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->day );
}

__PACKAGE__->meta->make_immutable;
1;
