package Recollect::RadminController;
use Moose;
use Plack::Request;
use Plack::Response;
use Recollect::User;
use JSON qw/encode_json/;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::SQL';

sub run {
    my $self = shift;
    my $req = $self->request;

    unless ($self->user_is_admin) {
        my $tweeter = $self->doorman->twitter_screen_name;
        $self->message("Sorry, $tweeter is not authorized.\n") if $tweeter;
        return $self->login_ui;
    }

    my $path = $req->path;
    my %func_map = (
        GET => [
            [ qr{^/sign_out$}           => sub { shift->redirect('/radmin') } ],
            [ qr{^/subscribers$}        => \&subscribers ],
            [ qr{^/subscribers/(\d+)$}  => \&show_subscriber ],
            [ qr{^/twitter_verified$}   => \&twitter_verified ],
            [ qr{^/$}                   => \&home_screen ],
        ],

        POST => [
        ],
    );
    
    my $method = $req->method;
    for my $match (@{ $func_map{$method}}) {
        my ($regex, $todo) = @$match;
        if ($path =~ $regex) {
            return $todo->($self, $1, $2, $3, $4);
        }
    }

    $self->message("Unknown path - $path");
    return $self->home_screen;
}

sub login_ui {
    my $self = shift;
    my $params = {
        doorman => $self->doorman,
    };
    return $self->process_template("radmin/login.tt2", $params)->finalize;
}

sub home_screen {
    my $self = shift;

    if (my $area = $self->user->area_admin) {
        my $params = {
            doorman => $self->doorman,
            area => $area,
        };
        return $self->process_template('radmin/area.tt2', $params)->finalize;
    }

    my $params = {
        doorman => $self->doorman,
        stats => $self->_gather_stats,
        reminders_by_area_json => $self->_reminders_by_area_json,
        reminders_over_time_json => $self->_reminders_over_time_json,
        new_reminders => $self->_new_reminders,
    };
    return $self->process_template("radmin/home.tt2", $params)->finalize;
}

sub subscribers {
    my $self = shift;
    my $params = {
        subscribers => Recollect::User->All_active,
    };
    return $self->process_template("radmin/subscribers.tt2", $params)->finalize;
}

sub show_subscriber {
    my $self = shift;
    my $id = shift;
    my $params = {
        subscriber => Recollect::User->By_id($id),
    };
    return $self->process_template("radmin/subscriber.tt2", $params)->finalize;
}

sub twitter_verified { shift->redirect("/radmin") }

sub _gather_stats {
    my $self = shift;

    return {
        table_size => {
            map { $_ => $self->sql_singlevalue("SELECT COUNT(*) FROM $_") }
                qw/users areas zones pickups subscriptions reminders
                   place_interest place_notify/
        },
    };
}

sub _reminders_by_area_json {
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
    return encode_json([
            grep { $_->{label} ne 'Vancouver' }
            map { 
                label => $_->[0],
                data => int $_->[1],
                }, @$result 
            ]);
}

sub _reminders_over_time_json {
    my $self = shift;
    my $sth = $self->run_sql(<<EOSQL, []);
SELECT area_name, created_at, COUNT(created_at) FROM (
        SELECT date_trunc('day', created_at) AS created_at, area.name AS area_name
            FROM reminders reminder
            JOIN zones zone ON (reminder.zone_id = zone.id)
            JOIN areas area ON (zone.area_id = area.id)
            ) R
    GROUP BY area_name, created_at
    ORDER BY created_at ASC
EOSQL

    my %cities;
    my %dates;
    for my $row (@{  $sth->fetchall_arrayref }) {
        my ($name, $date, $count) = @$row;
        next if $name eq 'Vancouver';
        $date =~ s/ .+//;
        my @date = split '-', $date;
        my $dt = DateTime->new(year => $date[0], month => $date[1], day => $date[2]);
        $date = $dt->epoch * 1000;

        $cities{$name} ||= { label => $name };

        $cities{$name}{dates}{$date} = $count;
        $dates{$date}++;
    }

    my %rolling_count;
    for my $day (sort keys %dates) {
        for my $area (keys %cities) {
            my $count = ($rolling_count{$area}||0) + ($cities{$area}{dates}{$day} || 0);
            push @{ $cities{$area}{data} }, [$day, $count];
            $rolling_count{$area} = $count;
        }
    }
    for my $area (keys %cities) {
        delete $cities{$area}{dates};
    }

    return encode_json [ values %cities ];
}

sub _new_reminders {
    my $self = shift;

    my $sth = $self->run_sql(<<EOSQL);
SELECT * from reminders
 WHERE created_at > 'now'::timestamptz - '2days'::interval
 ORDER BY created_at DESC
EOSQL
    return [
        map { Recollect::Reminder->new($_)->to_hash }
        @{ $sth->fetchall_arrayref({}) }
    ];
}

__PACKAGE__->meta->make_immutable;
1;
