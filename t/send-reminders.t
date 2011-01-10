#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use DateTime;
use DateTime::Duration;

BEGIN {
    use_ok 'Recollect::Notifier';
    use_ok 'Recollect::Subscription';
}

t::Recollect->model(); # set up the db model

my $notifier = Recollect::Notifier->new;
ok $notifier, 'notifier exists';

my $TEST_EMAIL = 'unittest@recollect.net';
my $one_hour = DateTime::Duration->new(hours => 1);
$ENV{RECOLLECT_NOW} = DateTime->new(year => 2011, month => 1, day => 15);

subtest 'No reminders need notification initially' => sub {
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 0;
};

subtest 'Free reminder notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "email:$TEST_EMAIL",
                offset => 0,
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    my $before_offset = $next_pickup - $rem->offset_duration - $one_hour;
    $notifier->now($before_offset);
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 0, 'no reminder before the right time';
    my $after_offset = $next_pickup - $rem->offset_duration + $one_hour;
    $notifier->now($after_offset);
    $rems = $notifier->need_notification;
    is scalar(@$rems), 1, 'reminder after works correctly';

    $notifier->notify($rems->[0]);

    my $content = t::Recollect::email_content(); t::Recollect::clear_email();
    like $content, qr#/subscription/delete/[\w-]+#, 'email has delete url';

    # Now move the clock forward and check again
    $notifier->now($after_offset);
    $rems = $notifier->need_notification;
    is scalar(@$rems), 0, 'reminder was sent';
};

# fake send them
# Check how many reminders need to be sent: 0
# Test that offset works properly
# create a paid+free subscription
# no notifications until paid
# notification should not be double sent
# email notifications work & match
# twitter notifications work & match
# webhooks notifications work & match
# sms notifications work & match
# voice notifications work & match


done_testing();
exit;
