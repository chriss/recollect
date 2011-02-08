package Recollect::RadminController;
use Moose;
use Plack::Request;
use Plack::Response;
use Recollect::User;
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
        top_places => $self->_top_10_requested_places,
    };
}

sub _top_10_requested_places {
    my $self = shift;
    my $sth = $self->run_sql(
        'SELECT place, COUNT(place) as count FROM place_interest
            GROUP BY place
            ORDER BY count DESC
            LIMIT 10'
    );
    return $sth->fetchall_arrayref({});
}

__PACKAGE__->meta->make_immutable;
1;
