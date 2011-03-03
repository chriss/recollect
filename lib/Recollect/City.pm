package Recollect::City;
use Moose;
use Recollect::Zone;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';
with 'Recollect::Roles::Cacheable';

has 'id'          => (is => 'ro', isa => 'Int',        required => 1);
has 'name'        => (is => 'ro', isa => 'Str',        required => 1);
has 'ad_img'      => (is => 'ro', isa => 'Maybe[Str]');
has 'licence_url' => (is => 'ro', isa => 'Maybe[Str]');

has 'zones' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);

sub db_table { 'cities' }

sub to_hash {
    my $self = shift;
    return {
        map { $_ => $self->$_() } qw/id name ad_img licence_url/
    };
}

sub _build_zones {
    my $self = shift;
    return Recollect::Zone->By_city_id($self->id);
}

__PACKAGE__->meta->make_immutable;
1;
