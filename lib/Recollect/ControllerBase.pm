package Recollect::ControllerBase;
use Moose::Role;
use Recollect::Template;
use Recollect::Model;
use Recollect::Paypal;
use JSON qw/encode_json decode_json/;

with 'Recollect::Config';
with 'Recollect::Log';

our $Recollect_version = '0.9';

has 'base_path' => (is => 'ro', isa => 'Str',    lazy_build => 1);
has 'template'  => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'request'   => (is => 'rw', isa => 'Plack::Request');
has 'model' => (is => 'ro', isa => 'Recollect::Model', lazy_build => 1);

around 'run' => sub {
    my $orig = shift;
    my $self = shift;
    my $env  = shift;

    $self->request( Plack::Request->new($env) );
    return $orig->($self, $env);
};

sub _build_model {
    my $self = shift;
    my $model = Recollect::Model->new(
        base_path => $self->base_path,
    );
    # Set the model in the Paypal singleton.
    Recollect::Paypal->new(model => $model);
    return $model;
}

sub _build_base_path {
    my $self = shift;
    return $ENV{RECOLLECT_BASE_PATH} || '/var/www/recollect';
}

sub _build_template {
    my $self = shift;
    return Recollect::Template->new( base_path => $self->base_path );
}

sub response {
    my $self = shift;
    my $ct   = shift;
    my $body = shift;
    return Plack::Response->new(200, ['Content-Type' => $ct], $body)->finalize;
}

sub render_template {
    my $self = shift;
    my $template = shift;
    my $param = shift;
    my $html;
    $param->{version} = $Recollect_version;
    $param->{base} = $self->base_url,
    $param->{request_uri} = $self->request->request_uri;
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

sub process_json {
    my $self = shift;
    my $data = shift;

    return $self->response('application/json' => encode_json($data));
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

sub ok {
    return Plack::Response->new(200, ['Content-Type' => 'text/plain'],
            'KTHXBYE')->finalize;
}


1;
