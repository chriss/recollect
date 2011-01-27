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
            [ qr{^/$}           => \&ui_html ],
            [ qr{^/m/?$}        => \&ui_html ],
            [ qr{^/(.+)\.html$} => \&ui_html ],
            [ qr{^/subscription/delete/([\w-]+)$} => \&delete_subscription_page ],
        ],

        POST => [
            # Website Actions
            [ qr{^/action/tell-friends$} => \&tell_friends ],
        ],
    );
    
    my $method = $req->method;
    for my $match (@{ $func_map{$method}}) {
        my ($regex, $todo) = @$match;
        if ($path =~ $regex) {
            return $todo->($self, $req, $1, $2, $3, $4);
        }
    }

    return $self->redirect("/404.html");
}

sub is_mobile {
    my ($self, $req) = @_;
    my $headers = $req->headers;
    my $ua_str = $headers->{'user-agent'} || '';
    return $ua_str =~ m{Android|iPhone|BlackBerry}i ? 1 : 0;
}

sub default_page {
    my ($self, $req) = @_;
    return $self->is_mobile($req) ? 'm/index' : 'index';
}

sub ui_html {
    my ($self, $req, $tmpl) = @_;
    $tmpl ||= $self->default_page($req);
    my $params = $req->parameters;
    $params->{host_port} = $req->uri->host_port;
    $params->{twitter} = $self->config->{twitter_username};
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

    return $self->process_template("delete_subscription.html", $sub->to_hash)
        ->finalize;
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
