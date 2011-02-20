package Recollect::Roles::Email;
use Moose::Role;
use Email::Send;
use Email::MIME;
use Email::MIME::Creator;
use Email::Send::IO;
use Net::SMTP::SSL;

requires 'config';
requires 'base_url';
requires 'tt2';

my $MAILER;
sub _mailer { $MAILER ||= shift->_build__mailer }

sub send_email {
    my $self = shift;

    if (@_ == 1) {
        $self->_mailer->send($_[0]);
        return;
    }

    my %args = @_;
    my $template = "email/$args{template}";
    $args{template_args}{base} = $self->base_url;
    my $body;
    $self->tt2->process($template, $args{template_args}, \$body);
    die "Error rendering $template: " . $self->tt2->error unless defined $body;

    my %headers = (
        From => $args{from} || 'Recollect <noreply@recollect.net>',
        To => $args{to},
        Subject => $args{subject},
    );
    my $email = Email::MIME->create(
        attributes => {
            content_type => $args{content_type}||'text/plain',
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
        no warnings 'redefine';
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

1;
