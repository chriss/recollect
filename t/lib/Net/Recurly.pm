package Net::Recurly;
use unmocked 'Moose';

our $STATE = 'active';

sub get_subscription {
    return {
        state => $STATE,
    };
}

1;
