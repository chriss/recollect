package Net::Recurly;
use unmocked 'Moose';

our $STATE = 'active';

sub get_subscription {
    return {
        state => $STATE,
    };
}

sub delete_account {}
sub create_account {}

1;
