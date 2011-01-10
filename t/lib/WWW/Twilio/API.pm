package WWW::Twilio::API;
use Moose;

our @POSTS;

sub POST {
    my $self = shift;
    push @POSTS, \@_;
    return { code => 201 }
}

__PACKAGE__->meta->make_immutable;
1;
