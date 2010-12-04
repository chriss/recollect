package Recollect::Email;
use Moose;
use Email::Send;
use Email::MIME;
use Email::MIME::Creator;
use Email::Send::IO;
use Net::SMTP::SSL;
use Recollect::Template;
use Recollect::Config;
use namespace::clean -except => 'meta';

has 'base_path' => (is => 'ro', isa => 'Str',    required   => 1);
has 'mailer'    => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'template' => (is => 'ro', lazy_build => 1);

sub send_email {
    my $self = shift;
    my %args = @_;

    my $body;
    my $template = "email/$args{template}";
    $args{template_args}{base} = Recollect::Config->instance->base_url();
    $self->template->process($template, $args{template_args}, \$body) 
        || die $self->template->error;

    my %headers = (
        From => $args{from} || 'Recollect <noreply@recollect.net>',
        To => $args{to},
        Subject => $args{subject},
    );
    my $email = Email::MIME->create(
        attributes => {
            content_type => 'text/plain',
            disposition => 'inline',
            charset => 'utf8',
        },
        body => $body,
    );
    $email->header_set( $_ => $headers{$_}) for keys %headers;

    $self->mailer->send($email);
}

sub _build_mailer {
    my $self = shift;

    if ($ENV{VT_EMAIL}) {
        @Email::Send::IO::IO = ($ENV{VT_EMAIL});
        return Email::Send->new({
            mailer => 'IO',
        });
    }

    my $config = Recollect::Config->instance;
    my $mailer_config = $config->Value('mailer') || 'Sendmail';

    my $mailer;
    if ($mailer_config eq 'Sendmail') {
        $mailer = Email::Send->new({ mailer => 'Sendmail' });
    }
    elsif ($mailer_config eq 'Gmail') {
        require Email::Send::Gmail;
        $mailer = Email::Send->new({
            mailer => 'Gmail',
            mailer_args => [
                username => $config->Value('gmail_username'),
                password => $config->Value('gmail_password'),
            ]
        });
    }
    else {
        die "Unknown mailer: $mailer_config";
    }

    return $mailer;
}

sub _build_template {
    my $self = shift;
    return Recollect::Template->new( base_path => $self->base_path );
}

__PACKAGE__->meta->make_immutable;
1;
