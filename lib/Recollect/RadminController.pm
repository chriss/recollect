package Recollect::RadminController;
use Moose;
use Plack::Request;
use Plack::Response;
use Recollect::User;
use JSON qw/encode_json/;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::SQL';

has 'doorman' => (is => 'rw', isa => 'Object', lazy_build => 1);

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
    my $params = {
        doorman => $self->doorman,
        stats => $self->_gather_stats,
        reminders_by_city_json => $self->_reminders_by_city_json,
    };
    return $self->process_template("radmin/home.tt2", $params)->finalize;
}

sub twitter_verified { shift->redirect("/radmin") }
sub _build_doorman   { shift->env->{'doorman.radmin.twitter'} }

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

sub _reminders_by_city_json {
    my $self = shift;
    my $sth = $self->run_sql(<<EOSQL, []);
SELECT city.name, COUNT(reminder.id)
    FROM reminders reminder
    JOIN zones zone ON (reminder.zone_id = zone.id)
    JOIN cities city ON (zone.city_id = city.id)
    JOIN subscriptions subscr ON (reminder.subscription_id = subscr.id)
    WHERE subscr.active
    GROUP BY city.name
EOSQL

    my $result = $sth->fetchall_arrayref({});
    return encode_json($result);

}

__PACKAGE__->meta->make_immutable;
1;
