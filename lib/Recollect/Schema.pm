package Recollect::Schema;
use base 'DBIx::Class::Schema';

# Autoload Recollect::Schema::Result::* packages
__PACKAGE__->load_namespaces();

1;
