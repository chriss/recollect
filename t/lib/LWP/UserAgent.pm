package LWP::UserAgent;
use unmocked 'Moose';

our @POSTS;

sub post {
    my $self = shift;
    push @POSTS, \@_;
}

1;
