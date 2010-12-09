package Recollect::User;
use Moose;
use DateTime;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'    => (is => 'ro', isa => 'Str', required => 1);
has 'email' => (is => 'ro', isa => 'Str', required => 1);
has 'created_at' => (is => 'ro', isa => 'Object',       required => 1);

sub to_hash {
    my $self = shift;
    return {
        id => $self->id,
        email => $self->email,
        created_at => $self->created_at,
    };
}

__PACKAGE__->meta->make_immutable;
1;
