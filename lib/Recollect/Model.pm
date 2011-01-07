package Recollect::Model;
use Moose;
use Recollect::KML;
use namespace::clean -except => 'meta';

has 'kml'       => (is => 'ro', isa => 'Object', lazy_build => 1);

sub _build_kml {
    my $self = shift;
    my $base = $self->base_path;
    my $filename = -d "$base/root"
            ? "$base/root/zones.kml"
            : "$base/static/zones.kml";
    return Recollect::KML->new(filename => $filename);
}

__PACKAGE__->meta->make_immutable;
1;
