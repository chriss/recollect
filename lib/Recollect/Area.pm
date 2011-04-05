package Recollect::Area;
use Moose;
use Recollect::Zone;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';
with 'Recollect::Roles::Cacheable';

has 'id'     => (is => 'ro', isa => 'Int',              required   => 1);
has 'name'   => (is => 'ro', isa => 'Str',              required   => 1);
*title = \&name;

has 'ad_img'                => (is => 'ro', isa => 'Maybe[Str]');
has 'ad_url'                => (is => 'ro', isa => 'Maybe[Str]');
has 'licence_name'          => (is => 'ro', isa => 'Maybe[Str]');
has 'licence_url'           => (is => 'ro', isa => 'Maybe[Str]');
has 'success_web_snippet'   => (is => 'ro', isa => 'Maybe[Str]');
has 'success_email_snippet' => (is => 'ro', isa => 'Maybe[Str]');
has 'logo_img'              => (is => 'ro', isa => 'Maybe[Str]');
has 'logo_url'              => (is => 'ro', isa => 'Maybe[Str]');
has 'background_img'        => (is => 'ro', isa => 'Maybe[Str]');

has 'uri'   => (is => 'ro', isa => 'Str',              lazy_build => 1);
has 'zones' => (is => 'ro', isa => 'ArrayRef[Object]', lazy_build => 1);
has 'styles' => (is => 'ro', isa => 'ArrayRef[HashRef]', lazy_build => 1);
has 'polygons' => (is => 'ro', isa => 'ArrayRef[HashRef]', lazy_build => 1);

around 'All' => sub {
    my $orig = shift;
    my $class = shift;
    return $orig->($class, {}, \"name ASC");
};

sub to_hash {
    my $self = shift;
    my %opts = @_;

    my @minimal_fields
        = qw/id name ad_img ad_url logo_img logo_url background_img/;
    my @all_fields
        = (@minimal_fields, qw/licence_name licence_url success_web_snippet/);

    return {
        map { $_ => $self->$_() }
            $opts{minimal} ? @minimal_fields : @all_fields
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
    return $zone;
}

sub _build_zones {
    my $self = shift;
    return Recollect::Zone->By_area_id($self->id);
}

sub _build_uri {
    my $self = shift;
    return "/api/areas/" . $self->name;
}

sub _build_styles {
    my $self = shift;

    # de-dup
    my %styles;
    for my $zone (@{ $self->zones }) {
        my $name = $zone->style->{colour_name};
        next if $styles{$name};
        $styles{$name} = $zone->style;
    }
    return [ values %styles ];
}

sub _build_polygons {
    my $self = shift;
    return [ map { @{$_->polygons} } @{ $self->zones } ];
}

__PACKAGE__->meta->make_immutable;
1;
