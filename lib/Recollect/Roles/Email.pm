package Recollect::Roles::Email;
use Moose::Role;
use Email::Send;
use Email::MIME;
use Email::MIME::Creator;
use Email::Send::IO;
use Net::SMTP::SSL;
use Recollect::Template;

requires 'config';
requires 'base_url';

has '_mailer' => (is => 'ro', isa => 'Object', lazy_build => 1);
has '_template' => (is => 'ro', lazy_build => 1);

sub send_email {
    my $self = shift;

    if (@_ == 1) {
        $self->_mailer->send($_[0]);
        return;
    }

    my %args = @_;
    my $body;
    my $template = "email/$args{template}";
    $args{template_args}{base} = $self->base_url();
    $self->_template->process($template, $args{template_args}, \$body) 
        || die $self->_template->error;

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

    $self->_mailer->send($email);
}

sub _build__mailer {
    my $self = shift;

    if ($ENV{RECOLLECT_EMAIL}) {
        @Email::Send::IO::IO = ($ENV{RECOLLECT_EMAIL});
        return Email::Send->new({
            mailer => 'IO',
        });
    }

    my $mailer_config = $self->config->{mailer} || 'Sendmail';

    my $mailer;
    if ($mailer_config eq 'Sendmail') {
        $mailer = Email::Send->new({ mailer => 'Sendmail' });
    }
    else {
        die "Unknown mailer: $mailer_config";
    }

    return $mailer;
}

sub _build__template {
    my $self = shift;
    return Recollect::Template->new;
}

1;