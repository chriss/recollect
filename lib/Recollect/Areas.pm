package Recollect::Areas;
use Moose;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

__PACKAGE__->meta->make_immutable;
1;
