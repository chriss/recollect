package Recollect::ControllerBase;
use Moose::Role;
use Recollect::Template;
use Recollect::Model;
use Recollect::Util qw/base_path/;
use JSON qw/encode_json decode_json/;

with 'Recollect::Roles::Config';
with 'Recollect::Roles::Log';

our $Recollect_version = '0.9';

has 'template'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'request'   => (is => 'rw', isa => 'Plack::Request');
has 'env'       => (is => 'rw', isa => 'HashRef');
has 'model' => (is => 'ro', isa => 'Recollect::Model', lazy_build => 1);
has 'message' => (is => 'rw', isa => 'Str');

around 'run' => sub {
    my $orig = shift;
    my $self = shift;
    my $env  = shift;

    $self->env($env);
    $self->request( Plack::Request->new($env) );
    return $orig->($self, $env);
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

sub _build_model { Recollect::Model->new }

sub _build_base_path { base_path() }

sub _build_template {
    my $self = shift;
    return Recollect::Template->new;
}

sub response {
    my $self = shift;
    my $ct   = shift;
    my $body = shift;
    my $code = shift || 200;
    return Plack::Response->new($code, [ 'Content-Type' => $ct ], $body)
        ->finalize;
}

sub render_template {
    my $self = shift;
    my $template = shift;
    my $param = shift;
    my $html;
    $param->{version} = $Recollect_version;
    $param->{base} = $self->base_url,
    $param->{request_uri} = $self->request->request_uri;
    $param->{message} = $self->message;
    $self->template->process($template, $param, \$html) 
        || die $self->template->error;
    return $html;
}

sub process_template {
    my $self = shift;
    my $template = shift;
    my $param = shift;
    my $resp = Plack::Response->new(200);
    $resp->body($self->render_template($template, $param));
    $resp->header('X-UA-Compatible' => 'IE=EmulateIE7');
    $resp->header('Content-Type' => 'text/html; charset=utf8');
    if ($template =~ m/\.txt$/) {
        $resp->header('Content-Type' => 'text/plain');
    }
    return $resp;
}

sub bad_request {
    my $self = shift;
    my $msg  = shift;
    
    my $resp = Plack::Response->new(400);
    $resp->content_type('text/plain');
    $resp->body($self->render_template('error.tt2', { msg => $msg }));
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

sub redirect {
    my $self = shift;
    my $url  = shift;
    my $code = shift || 302;

    my $resp = Plack::Response->new;
    $resp->redirect($url, 302);
    $resp->header('Content-Type' => 'text/plain');
    $resp->body('');
    return $resp->finalize;
}

1;
