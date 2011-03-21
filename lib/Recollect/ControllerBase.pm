package Recollect::ControllerBase;
use feature 'switch';
use Moose::Role;
use Recollect::Util qw/base_path is_dev_env/;
use JSON qw/encode_json decode_json/;
use File::Slurp qw(slurp);

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Template';

has 'request'   => (is => 'rw', isa => 'Plack::Request');
has 'env'       => (is => 'rw', isa => 'HashRef');
has 'message' => (is => 'rw', isa => 'Str');
has 'doorman' => (is => 'rw', isa => 'Object', lazy_build => 1);

has 'version' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
sub _build_version {
    my $self = shift;
    my $make_time = slurp( base_path() . '/root/make-time' );
    chomp $make_time;
    return "0.11.$make_time";
}

around 'run' => sub {
    my $orig = shift;
    my $self = shift;
    my $env  = shift;

    $self->env($env);
    $self->request( Plack::Request->new($env) );
    my $rc = eval { $orig->($self, $env) };
    if ($@) {
        warn $@;
        $self->log("Error processing " . $self->request->path . " - $@");
        if (is_dev_env()) {
            return $self->response('text/plain', "Error: $@", 500);
        }
        else {
            return $self->process_template("500.tt2", {}, 500);
        }
    }
    return $rc;
};

sub user_is_admin {
    my $self = shift;

    # Unit Test mode
    return $ENV{RECOLLECT_USER_IS_ADMIN} unless $self->can('doorman');

    return 0 unless $self->doorman->is_sign_in;

    my $tweeter = $self->doorman->twitter_screen_name;
    my $user = Recollect::User->By_twitter($tweeter);
    return 1 if $user and $user->is_admin;
    return 0;
}

sub _build_base_path { base_path() }

sub response {
    my $self = shift;
    my $ct   = shift;
    my $body = shift;
    my $code = shift || 200;
    return Plack::Response->new($code,
        [ 'Content-Type' => $ct, 'Content-Length' => length($body) ],
        $body)->finalize;
}

sub render_template {
    my $self = shift;
    my $template = shift;
    my $param = shift;
    my $html = shift;
    $param->{version} = $self->version;
    $param->{base} = $self->base_url,
    $param->{request_uri} = $self->request->request_uri;
    $param->{message} = $self->message;
    $param->{is_admin} = $self->user_is_admin ? 1 : 0;
    $self->tt2->process($template, $param, ref($html) ? $html : \$html);
    return \$html;
}

sub process_template {
    my $self = shift;
    my $template = shift;
    my $param = shift;
    my $code = shift || 200;
    my $body;
    $self->render_template($template, $param, \$body);
    if (!defined $body) {
        my $err = $self->tt2->error;
        if ($err =~ m/not found/) {
            return $self->process_template('404.tt2', {}, 404);
        }
        my $msg = "Error rendering template $template: $err";
        warn $msg;
        $self->log($msg);
        return $self->process_template("500.tt2", {}, 500);
    }
    my $resp = Plack::Response->new($code);
    $resp->body($body);
    $resp->header('X-UA-Compatible' => 'IE=EmulateIE7');
    given ($template) {
        when (m/\.txt$/) {
            $resp->header('Content-Type' => 'text/plain');
        }
        when (m/\.xml$/) {
            $resp->header('Content-Type' => 'application/xml; encoding=utf-8');
        }
        default {
            $resp->header('Content-Type' => 'text/html; charset=utf8');
        }
    };
    return $resp;
}

sub bad_request {
    my $self = shift;
    my $msg  = shift;
    
    my $resp = Plack::Response->new(400);
    $resp->content_type('text/plain');
    my $body;
    $self->render_template('error.tt2', { msg => $msg }, \$body);
    if (!defined $body) {
        $self->log(
            "Error rendering bad_request template: " . $self->tt2->error);
        return $self->zomg500;
    }
    $resp->body($body);
    $resp->header('X-UA-Compatible' => 'IE=EmulateIE7');
    $resp->header('Content-Type' => 'text/html; charset=utf8');
    return $resp->finalize;
}

sub bad_request_text {
    my $self = shift;
    my $msg  = shift;
    my $code = shift || 400;

    return $self->response('text/plain' => $msg, $code);
}

sub process_json {
    my $self = shift;
    my $data = shift;
    my $code = shift;

    return $self->response('application/json' => encode_json($data), $code);
}

sub process_text {
    my $self = shift;
    my $body = shift;
    return $self->response('text/plain' => $body);
}
    
sub bad_request_json {
    my $self = shift;
    my $msg  = shift;
    
    my $resp = Plack::Response->new(400);
    $resp->content_type('application/json');
    $resp->body(encode_json { msg => $msg });
    return $resp->finalize;
}

sub not_found {
    my $self = shift;
    $self->log("BAD API: " . $self->request->path);
    return Plack::Response->new(404, ['Content-Type' => 'text/plain'], '')->finalize;
}

sub _kthx {
    my $code = shift;
    return Plack::Response->new($code, ['Content-Type' => 'text/plain'],
            'KTHXBYE')->finalize;
}

sub ok         { _kthx(200) }
sub no_content { _kthx(204) }
sub forbidden  { _kthx(403) }

sub zomg500    {
    return Plack::Response->new(500, ['Content-Type' => 'text/plain'],
            'So sorry');
}

sub redirect {
    my $self = shift;
    my $url  = shift;
    my $code = shift || 302;

    my $resp = Plack::Response->new;
    $resp->redirect($url, $code);
    $resp->header('Content-Type' => 'text/plain');
    $resp->body("Redirecting to $url");
    return $resp->finalize;
}

sub _build_doorman   { shift->env->{'doorman.radmin.twitter'} }

1;
