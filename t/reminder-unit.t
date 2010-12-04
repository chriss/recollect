#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use t::Recollect;

$ENV{VT_LOAD_DATA} = 1;

Add_a_reminder: {
    my $model = t::Recollect->model;
    isa_ok $model, 'Recollect::Model';

    my $zones = $model->zones->all;
    isa_ok $zones, 'ARRAY';
    @$zones = sort { $a->{name} cmp $b->{name} } @$zones;
    my $zone = shift @$zones;

    is_deeply $model->reminders->all, [], 'is empty';

    my $rem = $model->add_reminder({
            name => "Test Reminder",
            email => 'test@recollect.net',
            zone => $zone->{name},
            target => 'email:test@recollect.net',
        },
    );

    is $rem->name,  'Test Reminder', 'name';
    is $rem->email, 'test@recollect.net', 'email';
    like $rem->id,  qr/^[\w\d-]+$/, 'id';
    is $rem->nice_zone, 'Vancouver-North-Blue', 'nice zone name';
    is scalar(@{ $model->reminders->all }), 1, 'one reminder';
    ok !$rem->is_expired, 'not expired';
}

Check_if_model_persists: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    is scalar(@$rems), 1, 'one reminder';
    ok !$rems->[0]->confirmed, 'not confirmed';
}

Confirm_reminder: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    $rems->[0]->confirmed(1);
    $rems->[0]->update;
    ok $rems->[0]->confirmed, 'confirmed';
}

Reload_and_check_confirmation: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    ok $rems->[0]->confirmed, 'confirmed';
}

Delete_reminder: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all('objects');
    $rems->[0]->delete;
    $rems = $model->reminders->all;
    is scalar(@$rems), 0, 'no reminders';
}

Reload_and_check_delete: {
    my $model = t::Recollect->model();
    my $rems = $model->reminders->all;
    is scalar(@$rems), 0, 'no reminders';
}

done_testing();
exit;

