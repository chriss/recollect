package Recollect::Roles::Twitter;
use Moose::Role;
use Net::Twitter;

requires 'config';

has 'twitter' => (is => 'ro', lazy_build => 1, 
    handles => ['new_direct_message', 'get_error']);

sub _build_twitter {
    my $self = shift;

    my $nt = Net::Twitter->new(
        traits    => [ 'WrapError', 'API::REST', 'OAuth' ],
        useragent => 'VanTrash',
        consumer_key    => $self->config->{twitter_consumer_key},
        consumer_secret => $self->config->{twitter_consumer_secret},
    );

    my $access_token = $self->config->{twitter_oauth_token};
    my $token_secret = $self->config->{twitter_oauth_token_secret};
    if ($access_token && $token_secret) {
        $nt->access_token($access_token);
        $nt->access_token_secret($token_secret);
    }
    unless ($nt->authorized) {
        die "Twitter OAuth client is not authorized. Update Vantrash config.\n";
    }
    return $nt;
}

1;
