#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;
use DateTime;
use DateTime::Duration;
use JSON qw/decode_json/;

BEGIN {
    use_ok 'Recollect::Zone';
    use_ok 'Recollect::Notifier';
    use_ok 'Recollect::Subscription';
}

t::Recollect->model(); # set up the db model

my $notifier = Recollect::Notifier->new;
ok $notifier, 'notifier exists';

my $TEST_EMAIL = 'unittest@recollect.net';
my $one_hour = DateTime::Duration->new(hours  => 1);
my $one_min  = DateTime::Duration->new(minutes => 1);
$ENV{RECOLLECT_NOW} = DateTime->new(year => 2011, month => 1, day => 15);

my $zone = Recollect::Zone->By_id(1);

subtest 'No reminders need notification initially' => sub {
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 0;
};

subtest 'Free email notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "email:$TEST_EMAIL",
                delivery_offset => '1:00',
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    my @tests = (
        [ $next_pickup - $one_hour - $one_hour => 0 => 'hour before due' ],
        [ $next_pickup - $one_hour - $one_min  => 0 => 'min before due' ],
        [ $next_pickup - $one_hour             => 1 => 'exactly due' ],
        [ $next_pickup - $one_hour + $one_min  => 1 => 'min after due' ],
        [ $next_pickup - $one_hour + $one_hour => 1 => 'hour after due' ],
        [ $next_pickup - $one_hour + $one_hour + $one_hour => 1 => '2 hours after due' ],
    );
    my $rems;
    for my $t (@tests) {
        my $before_offset = $t->[0];
        $notifier->now($before_offset);
        is scalar(@{ $rems = $notifier->need_notification }), $t->[1], $t->[2];
    }

    $notifier->notify($rems->[0]);

    my $content = t::Recollect::email_content(); t::Recollect::clear_email();
    like $content, qr#/subscription/delete/[\w-]+#, 'email has delete url';

    is scalar(@{ $notifier->need_notification }), 0, 'reminder was sent';
};

subtest 'Free twitter notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "twitter:test",
                delivery_offset => '0:00',
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    $notifier->now($next_pickup);
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 1, 'reminder needing notification is found';
    @Net::Twitter::MESSAGES = ();
    $notifier->notify($rems->[0]);
    my @msgs = @Net::Twitter::MESSAGES;
    is scalar(@msgs), 1, 'a twitter dm is found';
    is $msgs[0]->{to}, 'test', 'twitter recipient';
    is $msgs[0]->{msg}, qq{It's garbage day on Monday for Vancouver North Red - }
        . q{yard trimmings & food scraps will be picked up}, 'twitter body';
    is scalar(@{ $notifier->need_notification }), 0, 'reminder was sent';
};

subtest 'Free webhook notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "webhook:http://example.com",
                delivery_offset => '0:00',
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    $notifier->now($next_pickup);
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 1, 'reminder needing notification is found';
    @Net::Twitter::MESSAGES = ();
    $notifier->notify($rems->[0]);
    my @posts = @LWP::UserAgent::POSTS;
    is scalar(@posts), 1, 'a webhook post is found';
    is $posts[0][0], 'http://example.com';
    my $blob = eval { decode_json($posts[0][2]) };
    ok !$@, 'json okay';
    is scalar(@{ $notifier->need_notification }), 0, 'reminder was sent';
};

subtest 'Paid sms notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "sms:7787851357",
                delivery_offset => '0:00',
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    my @tests = (
        [ $next_pickup - $one_hour - $one_hour => 0 => 'hour before due' ],
        [ $next_pickup - $one_hour - $one_min  => 0 => 'min before due' ],
        [ $next_pickup - $one_hour             => 0 => 'exactly due' ],
        [ $next_pickup - $one_hour + $one_min  => 0 => 'min after due' ],
        [ $next_pickup - $one_hour + $one_hour => 0 => 'hour after due' ],
        [ $next_pickup - $one_hour + $one_hour + $one_hour => 0 => '2 hours after due' ],
    );
    my $rems;
    for my $t (@tests) {
        my $before_offset = $t->[0];
        $notifier->now($before_offset);
        is scalar(@{ $rems = $notifier->need_notification }), $t->[1], $t->[2];
    }

    $sub->mark_as_active;

    $notifier->now($next_pickup);
    $rems = $notifier->need_notification;
    is scalar(@$rems), 1, 'reminder needing notification is found';
    @WWW::Twilio::API::POSTS = ();
    $notifier->notify($rems->[0]);
    my @posts = @WWW::Twilio::API::POSTS;
    my $p = shift @posts;
    my ($type, %args) = @$p;
    is $type, 'SMS/Messages', 'type';
    is $args{Body}, q{It's garbage day on Monday for Vancouver North Red - yard trimmings & food scraps will be picked up}, 'body';
    is scalar(@{ $notifier->need_notification }), 0, 'reminder was sent';
};

subtest 'Paid voice notification' => sub {
    my $sub = Recollect::Subscription->Create(
        email => $TEST_EMAIL,
        reminders => [
            {
                zone_id => 1,
                target => "voice:7787851357",
                delivery_offset => '0:00',
            },
        ],
    );
    ok $sub, 'subscription was created';

    my $rem = $sub->reminders->[0];
    my $next_pickup = $rem->zone->next_pickup->[0]->datetime;

    $sub->mark_as_active;

    $notifier->now($next_pickup);
    my $rems = $notifier->need_notification;
    is scalar(@$rems), 1, 'reminder needing notification is found';
    @WWW::Twilio::API::POSTS = ();
    $notifier->notify($rems->[0]);
    my @posts = @WWW::Twilio::API::POSTS;
    my $p = shift @posts;
    my ($type, %args) = @$p;
    is $type, 'Calls', 'type';
    is $args{Called}, '7787851357', 'called';
    is $args{Url}, q{http://localhost/call/notify/vancouver-north-red}, 'url';
    is scalar(@{ $notifier->need_notification }), 0, 'reminder was sent';
};

done_testing();
exit;
