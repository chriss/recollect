package Recollect::Roles::Recurly;
use Moose::Role;
use Net::Recurly;
use Carp 'croak';

requires 'config';

has 'recurly' => (is => 'ro', isa => 'Object', lazy_build => 1);

sub _build_recurly {
    my $self = shift;
    return Net::Recurly->new(
        map {
            $_ => $self->config->{"recurly_$_"}
                    || croak "Config variable recurly_$_ is not defined!"
            } qw/username password subdomain/
    );
}

1;
