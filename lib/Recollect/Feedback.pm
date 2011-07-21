package Recollect::Feedback;
use Moose;
use namespace::clean -except => 'meta';

has 'email' => ( is => 'ro', isa => 'Str', required => 1 );
has 'question' => ( is => 'ro', isa => 'Str', required => 1 );
has 'fields' => ( is => 'ro', isa => 'HashRef', required => 1 );

has 'subject' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
sub _build_subject {
    my $self = shift;
    my $email = $self->email;
    return "Support Request from $email"
}

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Template';
with 'Recollect::Roles::Email';

sub send {
    my $self = shift;
    $self->send_email(
        from          => $self->email,
        to            => $self->config->{support_email},
        subject       => $self->subject,
        content_type  => 'text/html',
        template      => 'feedback.html',
        template_args => {
            email    => $self->email,
            question => $self->question,
            fields   => $self->fields,
        },
    );
    return 1;
}

__PACKAGE__->meta->make_immutable;
1;
