package Recollect::User;
use Moose;
use DateTime::Format::Pg;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';

has 'id'           => (is => 'ro', isa => 'Str',    required   => 1);
has 'email'        => (is => 'ro', isa => 'Str',    required   => 1);
has 'created_at'   => (is => 'ro', isa => 'Str',    required   => 1);
has 'twittername'  => (is => 'ro', isa => 'Str',    required   => 1);
has 'is_admin'     => (is => 'ro', isa => 'Bool',   required   => 1);
has 'created_date' => (is => 'ro', isa => 'Object', lazy_build => 1);

sub _build_created_date {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime($self->created_at);
}

sub By_email {
    my $class = shift;
    return $class->By_field('LOWER(email)' => lc shift);
}

sub By_twitter {
    my $class = shift;
    return $class->By_field('LOWER(twittername)' => lc shift);
}

sub to_hash {
    my $self = shift;
    return {
        email => $self->email,
        created_at => $self->created_at,
    };
}

__PACKAGE__->meta->make_immutable;
1;
