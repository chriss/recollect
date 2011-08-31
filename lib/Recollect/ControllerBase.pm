package Recollect::ControllerBase;
use feature 'switch';
use Moose::Role;
use Recollect::Util qw/base_path is_live/;
use JSON qw/encode_json decode_json/;
use File::Slurp qw(slurp);
use Try::Tiny;
use HTTP::Date qw/time2str/;

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';
with 'Recollect::Roles::Template';

has 'request'   => (is => 'rw', isa => 'Plack::Request');
has 'env'       => (is => 'rw', isa => 'HashRef');
has 'message' => (is => 'rw', isa => 'Str');
has 'doorman' => (is => 'rw', isa => 'Maybe[Object]', lazy_build => 1);
has 'user'    => (is => 'ro', isa => 'Maybe[Object]', lazy_build => 1);

has 'make_time' => (is => 'ro', isa => 'Str', lazy_build => 1);
sub _build_make_time {
    my $make_time = slurp( base_path() . '/root/make-time' );
    chomp $make_time;
    return $make_time;
}
has 'version' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
sub _build_version {
    my $self = shift;
    return "0.11." . $self->make_time;
}

has 'area_hostname' => (is => 'ro', isa => 'Str', lazy_build => 1);
sub _build_area_hostname {
    my $self = shift;
    my ($hostname) = $self->request->base->host =~ m/^([\w ]+)\.recollect\.net/;
    return $hostname && Recollect::Area->By_name($hostname) ? $hostname : '';
}

sub kml_content_type { 'application/vnd.google-earth.kml+xml' }

around 'run' => sub {
    my $orig = shift;
    my $self = shift;
    my $env  = shift;
    my $req  = Plack::Request->new($env);

    $self->env($env);
    $self->request($req);

    return try {
        $orig->($self, $env);
    }
    catch {
        my $path = $req->path;
        warn "API ERROR: $path - $_";
        $self->log("Error processing $path - $_");

        $self->send_email(
            body => "API: $path\n\nError: $_",
            to => 'luke@recollect.net',
            subject => 'Recollect API error',
        ) if is_live();

        if (($self->request->content_type // '') =~ m/html/) {
            $self->process_template("500.tt2", {}, 500)->finalize;
        }
        else {
            $self->bad_request_text(
                'Sorry, an error occurred. We will try to get that fixed soon.',
                500,
            );
        }
    };
};

sub user_is_admin {
    my $self = shift;

    # Unit Test mode
    return $ENV{RECOLLECT_USER_IS_ADMIN} unless $self->doorman;

    return 0 unless $self->doorman->is_sign_in;

    my $user = $self->user;
    return 1 if $user and $user->is_admin;
    return 1 if $user and $user->is_area_admin;
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
    if (my $ah = $self->area_hostname) {
        $param->{area} ||= Recollect::Area->By_name($ah);
    }
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
        my $msg = "Error rendering template $template: $err";
        warn $msg;
        if ($err =~ m/not found/) {
            return $self->process_template('404.tt2', {}, 404);
        }
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
        when (m/kml\.xml/) {
            $resp->header('Content-Type' => $self->kml_content_type);
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

sub _build_user {
    my $self = shift;
    return undef unless $self->doorman;
    my $tweeter = $self->doorman->twitter_screen_name;
    return undef unless $tweeter;
    return Recollect::User->By_twitter($tweeter);
}

1;
