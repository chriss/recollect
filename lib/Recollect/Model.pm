package Recollect::Model;
use Moose;
use Recollect::KML;
use namespace::clean -except => 'meta';

has 'kml'       => (is => 'ro', isa => 'Object', lazy_build => 1);

sub _build_kml {
    my $self = shift;
    my $base = $self->base_path;

    # XXX Luke fix this so vancouver isn't hardcoded:
    my $filename = -d "$base/root"
            ? "$base/root/kml/vancouver.xml"
            : "$base/static/kml/vancouver.xml";
    return Recollect::KML->new(filename => $filename);
}

__PACKAGE__->meta->make_immutable;
1;
