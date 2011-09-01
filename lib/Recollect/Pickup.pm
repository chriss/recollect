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
has 'flag_names' => (is => 'ro', isa => 'ArrayRef[Str]', lazy_build => 1);
has 'flags_desc' => (is => 'ro', isa => 'Str',      lazy_build => 1);
has 'datetime'   => (is => 'ro', isa => 'DateTime', lazy_build => 1,
                     handles => [ qw/ymd day_of_week/ ]);

extends 'Recollect::Collection';
with 'Recollect::Roles::HasZone';
with 'Recollect::Roles::Cacheable';

my %flag_map = (
    Y => 'Yard trimmings',
    G => 'Garbage',
    R => 'Recycling',
    C => 'Compost',
    F => 'Food Drive',
    X => 'Xmas Trees',
    2 => 'Two garbage bins',
);

sub _build_flag_names {
    my $self = shift;
    my @names;

    # Always put Garbage and Recycling first
    push @names, $flag_map{G} if $self->has_flag('G');;
    push @names, $flag_map{R} if $self->has_flag('R');;
    for my $flag (sort split '', $self->flags) {
        next if $flag eq 'G';
        next if $flag eq 'R';
        push @names, $flag_map{$flag} || die "Couldn't lookup flag $flag!";
    }
    return \@names;
}

sub _build_flags_desc {
    my $self = shift;

    my $items = $self->flag_names;
    return $items->[0] if @$items == 1;;
    my $last = pop @$items;
    return join(', ', @$items) . " and $last";
}

sub By_zone_id {
    my $class = shift;
    my $id    = shift;
    Recollect::Roles::HasZone::By_zone_id($class, $id, 
        args => [ ['day ASC'] ], @_);
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

sub has_flag {
    my $self = shift;
    my $flag = shift;
    die "Invalid flag: '$flag'" unless length($flag) == 1;
    return $self->flags =~ m/$flag/i;
}

sub _build_pretty_day {
    my $self = shift;
    my $dt = $self->datetime;
    return $dt->day_name . ', ' . $dt->month_name . ' ' . $dt->day;
}

sub _build_datetime {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime( $self->day );
}

__PACKAGE__->meta->make_immutable;
1;
