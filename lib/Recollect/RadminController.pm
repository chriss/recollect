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
