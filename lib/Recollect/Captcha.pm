package Recollect::Captcha;
use Moose;
use LWP::UserAgent;
use namespace::clean -except => 'meta';

use constant url => 'http://www.google.com/recaptcha/api/verify';

has 'challenge' => ( is => 'ro', isa => 'Str', required => 1 );
has 'remoteip'  => ( is => 'ro', isa => 'Str', required => 1 );
has 'response'  => ( is => 'ro', isa => 'Str', required => 1 );

has 'ua' => ( is => 'ro', isa => 'LWP::UserAgent', lazy_build => 1 );
sub _build_ua { LWP::UserAgent->new }

with 'Recollect::Roles::Config';

sub verify {
    my $self = shift;
    my $r = $self->ua->post($self->url, {
        privatekey => $self->config->{captcha_privatekey},
        challenge => $self->challenge,
        remoteip => $self->remoteip,
        response => $self->response,
    });
    return $r->is_success && $r->decoded_content =~ /^true\n/;
}

__PACKAGE__->meta->make_immutable;
1;
