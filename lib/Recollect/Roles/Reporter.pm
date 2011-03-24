package Recollect::Roles::Reporter;
use Moose::Role;

requires 'run_sql';

sub load_reminders_by_area {
    my $self = shift;

    my $sth = $self->run_sql(<<EOSQL, []);
SELECT area.name, COUNT(reminder.id)
    FROM reminders reminder
    JOIN zones zone ON (reminder.zone_id = zone.id)
    JOIN areas area ON (zone.area_id = area.id)
    JOIN subscriptions subscr ON (reminder.subscription_id = subscr.id)
    WHERE subscr.active
    GROUP BY area.name
EOSQL

    my $result = $sth->fetchall_arrayref;
    return [ map { label => $_->[0], data => int $_->[1], }, @$result ];
}

sub load_reminders_in_area {
    my $self      = shift;
    my $area_name = shift || return [];
    my $area      = Recollect::Area->By_name($area_name) || return [];

    my $sth = $self->run_sql(<<EOSQL, []);
SELECT zone.name, COUNT(reminder.id)
    FROM reminders reminder
    JOIN zones zone ON (reminder.zone_id = zone.id)
    JOIN areas area ON (zone.area_id = area.id)
    JOIN subscriptions subscr ON (reminder.subscription_id = subscr.id)
    WHERE subscr.active
    GROUP BY zone.name
EOSQL

    my $result = $sth->fetchall_arrayref;
    return [ map { label => $_->[0], data => int $_->[1], }, @$result ];
}

sub load_reminders_by_time {
    my $self = shift;
    my $area_name = shift;
    my $area;
    if ($area_name) {
        $area = Recollect::Area->By_name($area_name);
        return [] unless $area;
    }

    my $sth;
    if ($area) {
        $sth = $self->run_sql(<<EOSQL, [$area->id]);
SELECT zone_name, created_at, COUNT(created_at) FROM (
        SELECT date_trunc('day', created_at) AS created_at, zone.name AS zone_name
            FROM reminders reminder
            JOIN zones zone ON (reminder.zone_id = zone.id)
            JOIN areas area ON (zone.area_id = area.id)
            WHERE area.id = ?
            ) R
    GROUP BY zone_name, created_at
    ORDER BY created_at ASC
EOSQL
    }
    else {
        $sth = $self->run_sql(<<EOSQL, []);
SELECT area_name, created_at, COUNT(created_at) FROM (
        SELECT date_trunc('day', created_at) AS created_at, area.name AS area_name
            FROM reminders reminder
            JOIN zones zone ON (reminder.zone_id = zone.id)
            JOIN areas area ON (zone.area_id = area.id)
            ) R
    GROUP BY area_name, created_at
    ORDER BY created_at ASC
EOSQL
    }

    my %region;
    my %dates;
    for my $row (@{  $sth->fetchall_arrayref }) {
        my ($name, $date, $count) = @$row;
        $date =~ s/ .+//;
        my @date = split '-', $date;
        my $dt = DateTime->new(year => $date[0], month => $date[1], day => $date[2]);
        $date = $dt->epoch * 1000;

        $region{$name} ||= { label => $name };

        $region{$name}{dates}{$date} = $count;
        $dates{$date}++;
    }

    my %rolling_count;
    for my $day (sort keys %dates) {
        for my $area (keys %region) {
            my $count = ($rolling_count{$area}||0) + ($region{$area}{dates}{$day} || 0);
            push @{ $region{$area}{data} }, [$day, $count];
            $rolling_count{$area} = $count;
        }
    }
    for my $area (keys %region) {
        delete $region{$area}{dates};
    }

    return [ values %region ];
}

1;
