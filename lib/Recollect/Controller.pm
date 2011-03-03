package Recollect::Controller;
use feature 'switch';
use Moose;
use Fatal qw/open/;
use Template;
use Recollect::CallController;
use Recollect::Subscription;
use JSON qw/encode_json decode_json/;
use Email::Valid;
use Plack::Request;
use Plack::Response;
use Data::Dumper;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::Email';

sub run {
    my $self = shift;
    my $env = shift;
    my $req = $self->request;

    my $coord = qr{[+-]?\d+\.\d+};

    my $path = $req->path;
    my %func_map = (
        GET => [
            [ qr{^/$}           => \&ui_html ], # Landing page
            [ qr{^/r/.+}        => \&ui_html ], # HTML5 wizard
            [ qr{^/(m/.+)}      => \&ui_html ], # Mobile wizard
            [ qr{^/(.+)\.html$} => \&ui_html ], # Rendered pages
            [ qr{^/([\w-]+)$}   => \&ui_html ], # Same, but make the .html optional

            # Delete subscription link confirmation page:
            [ qr{^/subscription/delete/([\w-]+)$} => \&delete_subscription_page ],
            # Payment success / cancel page
            [ qr{^/payment/([^/]+)/(.+)$} => \&payment_ui ],
        ],

        POST => [
            [ qr{^/action/tell-friends$} => \&tell_friends ],
        ],
    );
    
    my $method = $req->method;
    $method = 'GET' if $method eq 'HEAD';
    for my $match (@{ $func_map{$method}}) {
        my ($regex, $todo) = @$match;
        if ($path =~ $regex) {
            return $todo->($self, $req, $1, $2, $3, $4);
        }
    }

    $self->log("Couldn't serve path: $method $path");
    return $self->process_template("404.tt2", {}, 404)->finalize;
}

sub is_mobile {
    my ($self, $req) = @_;
    my $headers = $req->headers;
    my $ua_str = $headers->{'user-agent'} || '';
    return $ua_str =~ m{Android|iPhone|BlackBerry}i ? 1 : 0;
}

sub default_page {
    my ($self, $req) = @_;
    # return $self->is_mobile($req) ? 'm/index' : 'index';
    return 'index';
}

sub ui_html {
    my ($self, $req, $tmpl) = @_;
    return $self->redirect('/m/index') if $self->is_mobile($req) and !$tmpl;
    $tmpl ||= $self->default_page($req);
    my $params = $req->parameters;
    $params->{host_port} = $req->uri->host_port;
    $params->{twitter} = $self->config->{twitter_username};
    $params->{analytics_id} = $self->config->{analytics_id};
    return $self->process_template("$tmpl.tt2", $params)->finalize;
}

sub delete_subscription_page {
    my $self = shift;
    my $req  = shift;
    my $id   = shift;

    my $sub = Recollect::Subscription->By_id($id);
    unless ($sub) {
        return $self->process_template("invalid_subscription.html", {
            account_code => $id,
        })->finalize;
    }

    if ($req->parameters->{confirm}) {
        $sub->delete;
        $self->log("Subscription deleted - $id");
        return $self->process_template("delete_subscription_confirmed.html", {
            })->finalize;
    }

    return $self->process_template("delete_subscription.html", {
            subscription => $sub,
        })->finalize;
}

sub payment_ui {
    my $self = shift;
    my $req  = shift;
    my $type = shift;
    my $id   = shift;

    my $sub = Recollect::Subscription->By_id($id)
        or return $self->redirect('/');

    given ($type) {
        when ('success') {
            return $self->process_template("payment_success.html", {
                subscription => $sub,
            })->finalize;
        }
        when ('cancel') {
            $self->log("PAYMENT_CANCEL - $id - " . $sub->user->email);
            $sub->delete;
        }
    }
    return $self->redirect("/");
}

sub tell_friends {
    my $self = shift;
    my $req  = shift;
    my $params = $req->parameters;

    my $tmpl_params = {};
    my $email_str = $params->{friend_emails};
    my $skill_str = $params->{skilltesting} || '';
    my $sender_email = $params->{sender_email};
    if (lc($skill_str) ne 'bc') {
        $tmpl_params->{error} = 'Please answer the Skill testing question correctly.';
        $self->log("TELLAFRIEND_FAIL - skilltest");
    }
    elsif ($email_str and $sender_email) {
        my @emails = split qr/\s*,?\s+/, $email_str;
        
        for my $email (@emails) {
            $self->send_email(
                to => $email,
                from => $sender_email,
                subject => "Meet the Vancouver Garbage Reminder system",
                template => 'tell-a-friend.html',
                content_type => 'text/html',
                template_args => {
                    friend_email => $sender_email,
                    base => $self->base_url,
                    request_uri => $self->request->request_uri,
                },
            );
        }

        $tmpl_params->{success} = "Email sent.  Thanks!";
        $self->log("TELLAFRIEND " . scalar(@emails));
    }
    else {
        $tmpl_params->{error} = 'Please fill out both fields.';
        $self->log("TELLAFRIEND_FAIL - incomplete form");
    }
    
    return $self->process_template('tell-a-friend.tt2', $tmpl_params)->finalize;
}

__PACKAGE__->meta->make_immutable;
1;
