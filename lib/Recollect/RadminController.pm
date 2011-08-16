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
    my %badmin_map = (
        GET => [
            [ qr{^/$}                   => \&home_screen ],
            [ qr{^/sign_out$}           => sub { shift->redirect('/radmin') } ],
            [ qr{^/twitter_verified$}   => \&twitter_verified ],
            [ qr{^/data/ads/(.+)$}      => \&area_ad_data ],
        ],
    );
    my %radmin_map = (
        GET => [
            [ qr{^/subscribers$}        => \&subscribers ],
            [ qr{^/subscribers/(\d+)$}  => \&show_subscriber ],
            [ qr{^/data/ad_clicks$}     => \&ad_clicks ],
            [ qr{^/data/recent_subscriptions$} => \&recent_subs ],
            [ qr{^/data/object_stats$} => \&object_stats ],
            [ qr{^/data/needs_pickups$} => \&needs_pickups ],
            [ qr{^/data/place_interest$} => \&place_interest ],
        ],
    );
    
    my $method = $req->method;

    my $resp;
    my $matcher = sub {
        for my $match (@_) {
            my ($regex, $todo) = @$match;
            if ($path =~ $regex) {
                $resp ||= $todo->($self, $1, $2, $3, $4);
                last;
            }
        }
    };
    $matcher->( @{ $badmin_map{$method} } );
    $matcher->( @{ $radmin_map{$method} } )
        unless $self->user->area_admin;
    return $resp if $resp;

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

sub ad_clicks {
    my $self = shift;

    die "not done";
#     my $sth = $self->run_sql(
#         'select area_id, count(at) from ad_clicks group by area_id order by count(at) desc',
}

sub area_ad_data {
    my $self = shift;
    my $aname = shift;

    my $area = Recollect::Area->By_name($aname);
    return $self->not_found unless $area;

    if (my $aadmin = $self->user->area_admin) {
        return $self->not_found unless $area->id == $aadmin->id;
    }

    return $self->process_json({ ohai => 'there' });
}

sub home_screen {
    my $self = shift;

    my $params = {
        area => $self->user->area_admin,
        areas => encode_json([
            map { $_->name } @{Recollect::Area->All}
        ]),
        doorman => $self->doorman,
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

sub _new_reminders {
    my $self = shift;
    my $days = shift || 2;

    $days .= "days";
    my $sth = $self->run_sql(<<EOSQL, [$days]);
SELECT * from reminders
 WHERE created_at > 'now'::timestamptz - ?::interval
 ORDER BY created_at DESC
EOSQL
    return [
        map { Recollect::Reminder->new($_)->to_hash(minimal => 1) }
        @{ $sth->fetchall_arrayref({}) }
    ];
}

sub recent_subs {
    my $self = shift;
    my $days = $self->request->parameters->{days};
    return $self->bad_request("Bad days parameter")
        unless !$days || $days =~ m/^\d+$/;
    return $self->process_json($self->_new_reminders($days));
}

sub object_stats {
    my $self = shift;

    return $self->process_json({
        table_size => {
            map { $_ => $self->sql_singlevalue("SELECT COUNT(*) FROM $_") }
                qw/users areas zones pickups subscriptions reminders
                   place_interest place_notify ical_users ad_clicks/
        },
    });
}

sub needs_pickups {
    my $self = shift;
    my $months = $self->request->parameters->{months} || 3;
    return $self->bad_request("Bad months parameter")
        unless !$months || $months =~ m/^\d+$/;

    $months .= "months";
    my $sth = $self->run_sql(<<EOT, [$months]);
SELECT id FROM (
    SELECT z.id, MAX(day) AS last
      FROM pickups p JOIN zones z ON (p.zone_id = z.id)
     GROUP BY z.id
     ORDER BY MAX(day) ASC) AS X
 WHERE last < 'now'::timestamptz + ?::interval
EOT
    return $self->process_json([
        map { Recollect::Zone->By_id($_->{id})->to_hash(minimal => 1) }
        @{ $sth->fetchall_arrayref({}) }
    ]);
}

sub place_interest {
    my $self = shift;
    my $since = $self->request->parameters->{since} || '2011-01-01';
    unless ($since =~ m/^\d{4}-\d\d-\d\d$/) {
        return $self->bad_request("Parameter since should be in format YYYY-MM-DD");
    }

    my $sth = $self->run_sql(<<EOT, [$since]);
SELECT at, ST_AsText(point) AS point FROM place_interest pi
    WHERE at > ?::timestamptz
      AND NOT EXISTS (
          SELECT 1 from zones where ST_Contains(geom, pi.point)
      )
EOT
    my @points;
    for my $p (@{ $sth->fetchall_arrayref({}) }) {
        next unless $p->{point} =~ m/^POINT\(([-\d.]+) ([-\d.]+)\)$/;
        push @points, { lat => $1, lon => $2, at => $p->{at} };
    }
    return $self->process_json( \@points );
}

__PACKAGE__->meta->make_immutable;
1;
