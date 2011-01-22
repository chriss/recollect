package Recollect::Roles::Cacheable;
use Moose::Role;
use Cache::FastMmap;

around 'By_field' => sub {
    my $orig = shift;
    my ($class, $field, $value, %args) = @_;

    # Cache just straight id lookups for now
    if ($field eq 'id' and not $args{handle_pls}) {
        my $cache_str = join '-', $class, $value;
        my $hash = $class->cache->get($cache_str) || do {
            my $sth = $orig->(@_, handle_pls => 1);
            my $row = $sth->fetchrow_hashref;
            $class->cache->set($cache_str, $row);
            $row;
        };
        return $class->new($hash) if $hash;
    }

    $orig->(@_);
};

our $CACHE;
sub cache {$CACHE}
BEGIN { $CACHE = Cache::FastMmap->new() }

1;
