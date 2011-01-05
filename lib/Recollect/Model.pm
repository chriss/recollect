package Recollect::Model;
use Moose;
use Recollect::KML;
use DateTime;
use namespace::clean -except => 'meta';

with 'Recollect::Roles::Config';

has 'base_path' => (is => 'ro', isa => 'Str',    required   => 1);
has 'mailer'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'notifier'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'kml'       => (is => 'ro', isa => 'Object', lazy_build => 1);

sub now {
    return $ENV{RECOLLECT_NOW} if $ENV{RECOLLECT_NOW};
    my $self = shift;
    my $dt = DateTime->now;
    $dt->set_time_zone('America/Vancouver');
    return $dt;
}

sub tonight {
    my $self = shift;
    my $now = $self->now;
    $now->set( hour => 23, minute => 59 );
}

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
