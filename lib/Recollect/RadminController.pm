package Recollect::RadminController;
use Moose;
use Plack::Request;
use Plack::Response;
use Recollect::User;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';

has 'doorman' => (is => 'rw', isa => 'Object', lazy_build => 1);

sub run {
    my $self = shift;
    my $req = $self->request;

    return $self->login_ui unless $self->doorman->is_sign_in;

    my $tweeter = $self->doorman->twitter_screen_name;
    my $user = Recollect::User->By_twitter($tweeter);
    unless ($user and $user->is_admin) {
        $self->message("Sorry, $tweeter is not authorized.\n");
        return $self->login_ui;
    }

    my $path = $req->path;
    my %func_map = (
        GET => [
            [ qr{^/sign_out$}           => sub { shift->redirect('/radmin') } ],
            [ qr{^/twitter_verified$}   => \&twitter_verified ],
            [ qr{^/home$}               => \&home_screen ],
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

    return $self->login_ui;
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
    };
    return $self->process_template("radmin/home.tt2", $params)->finalize;
}

sub twitter_verified { shift->redirect("/radmin/home") }
sub _build_doorman   { shift->env->{'doorman.radmin.twitter'} }

__PACKAGE__->meta->make_immutable;
1;
