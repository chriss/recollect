package Recollect::AdminController;
use Moose;
use Plack::Request;
use Plack::Response;
use Recollect::User;
use JSON qw/encode_json/;
use Crypt::Eksblowfish::Bcrypt;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::SQL';

sub Authenticator {
    my ($doorman, $env) = @_;
    my $request = Plack::Request->new($env);

    my $email = $request->param('username');
    my $pass = $request->param('password');
    my $user = Recollect::User->By_email($email);
    if ($user and $pass and $user->is_area_admin) {
        my $h = $user->passhash;
        if (Crypt::Eksblowfish::Bcrypt::bcrypt($pass, $h) eq $h) {
            return $email;
        }
    }
    return undef;
}

sub run {
    my $self = shift;
    my $req = $self->request;

    my $path = $req->path;
    my %world_readable = (
        GET => [
            [ qr{^/sign_out$}           => sub { shift->redirect('/admin') } ],
            [ qr{^/password-reset$}     => \&password_reset ],
            [ qr{^/password-reset/([0-9A-F\-]+)$} => \&password_reset_confirm ],
        ],
        POST => [
            [ qr{^/password-reset$}     => \&POST_password_reset ],
        ],
    );
    my %restricted_paths = (
        GET => [
            [ qr{^/$}                   => \&home_screen ],
            [ qr{^/sign_in$}           => sub { shift->redirect('/') } ],
        ],
    );
    
    my $method = $req->method;

    my $resp;
    my $matcher = sub {
        for my $match (@_) {
            last if $resp;
            my ($regex, $todo) = @$match;
            if ($path =~ $regex) {
                $resp ||= $todo->($self, $1, $2, $3, $4);
            }
        }
    };
    $matcher->(@{ $world_readable{$method} });
    return $resp || $self->login_ui unless $self->user_is_admin;
    $matcher->(@{ $restricted_paths{$method} });
    return $resp if $resp;

    $self->message("Unknown path - $path");
    return $self->home_screen;
}

sub login_ui {
    my $self = shift;
    my $params = {
        doorman => $self->admin_doorman,
    };
    return $self->process_template("admin/login.tt2", $params)->finalize;
}

sub home_screen {
    my $self = shift;

    my $params = {
        # area => $self->user->area_admin,
        doorman => $self->admin_doorman,
    };
    return $self->process_template("admin/home.tt2", $params)->finalize;
}

sub password_reset {
    my $self = shift;
    return $self->process_template("admin/password-reset.tt2")->finalize;
}

sub password_reset_confirm {
    my $self = shift;
    my $hash = shift;
    my $user = Recollect::User->By_reset_passhash($hash);
    return $self->redirect("/admin") unless $user;
    return $self->process_template("admin/password-reset.tt2", {
            hash => $hash,
            user => $user,
        })->finalize;
}

sub _check_new_password {
    my $self = shift;
    my $p1 = $self->request->param('password1');
    my $p2 = $self->request->param('password2');
    unless ($p1 eq $p2) {
        $self->message("Try again, the passwords do not match.");
        return undef;
    }
    unless (length($p1) >= 6) {
        $self->message("Please choose a longer password.");
        return undef;
    }
    return $p1;
}

sub POST_password_reset {
    my $self = shift;

    my $hash = $self->request->param('hash');
    if (my $user = Recollect::User->By_reset_passhash($hash) and $hash) {
        if (my $newpass = $self->_check_new_password) {
            $user->set_password($newpass);
            $self->message("Password has been saved. Please login.");
            return $self->login_ui;
        }
        else {
            return $self->process_template("admin/password-reset.tt2", {
                    hash => $hash,
                    user => $user,
                })->finalize;
        }
    }
    elsif (my $email = $self->request->param('email')) {
        if (my $user = Recollect::User->By_email($email)) {
            $user->reset_password;
            $self->message("Check your email for a password reset link.");
        }
        else {
            $self->message("Sorry, that user could not be found.");
        }
    }
    else {
        $self->message("Please enter an email address.");
    }
    return $self->process_template("admin/password-reset.tt2")->finalize;
}

__PACKAGE__->meta->make_immutable;
1;
