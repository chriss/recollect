package Recollect::Controller;
use Moose;
use Fatal qw/open/;
use Template;
use Recollect::CallController;
use Recollect::Paypal;
use JSON qw/encode_json decode_json/;
use Email::Valid;
use Plack::Request;
use Plack::Response;
use Business::PayPal::IPN;
use Data::Dumper;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';

has 'paypal' => (is => 'ro', isa => 'Recollect::Paypal', lazy_build => 1);

sub run {
    my $self = shift;
    my $env = shift;
    my $req = $self->request;

    my $coord = qr{[+-]?\d+\.\d+};

    my $path = $req->path;
    my %func_map = (
        GET => [
            [ qr{^/$}                               => \&ui_html ],
            [ qr{^/m/?$}                            => \&ui_html ],
            [ qr{^/(.+)\.html$}                     => \&ui_html ],

            # Confirmations
#             [ qr{^/zones/([^/]+)/reminders/([\w\d-]+)/confirm$} =>
#                     \&confirm_reminder ],
#             [ qr{^/zones/([^/]+)/reminders/([\w\d-]+)/delete$} => 
#                     \&delete_reminder_html ],


            # Billing
            [ qr{^/billing/proceed$} => \&payment_proceed ],
            [ qr{^/billing/cancel$}  => \&payment_cancel ],
        ],

        POST => [
            # Website Actions
            [ qr{^/action/tell-friends$} => \&tell_friends ],

            # Billing
            [ qr{^/billing/ipn$} => \&handle_paypal_ipn ],
        ],
    );
    
    my $method = $req->method;
    for my $match (@{ $func_map{$method}}) {
        my ($regex, $todo) = @$match;
        if ($path =~ $regex) {
            return $todo->($self, $req, $1, $2, $3, $4);
        }
    }

    return Plack::Response->new(404, ['Content-Type' => 'text/plain'], '')->finalize;
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
    $params->{zones} = $self->model->zones->all;
    $params->{host_port} = $req->uri->host_port;
    $params->{twitter} = $self->config->Value('twitter_username');
    return $self->process_template("$tmpl.tt2", $params)->finalize;
}

sub payment_cancel {
    my $self = shift;
    my $req  = shift;

    my $res = Plack::Response->new;
    $res->redirect("/");
    return $res->finalize;
}

sub payment_proceed {
    my $self = shift;
    my $req  = shift;

    my $token = $req->parameters->{token};
    unless ($token) {
        my $res = Plack::Response->new;
        $res->redirect("/");
        return $res->finalize;
    }

    my $rem = eval {$self->paypal->create_subscription($token)};
    if ($@) {
        $self->log("PAYMENT_PROCEED_FAIL $@");
        return $self->_400_bad_request("Sorry, we had some trouble.");
    }

    $self->model->confirm_reminder($rem);

    my %param = (reminder => $rem);
    return $self->process_template('zones/reminders/payment.html', \%param)->finalize;
}

sub confirm_reminder {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $hash = shift;
            
    my $is_mobile = $self->is_mobile($req);

    my $rem = $self->model->reminders->by_hash($hash);
    unless ($rem) {
        my $resp = $self->process_template(
            $is_mobile
                ? 'm/reminder_bad_confirm.tt2'
                : 'zones/reminders/bad_confirm.html'
        );
        $resp->status(404);
        $self->log("CONFIRM_FAIL $zone $hash");
        return $resp->finalize;
    }

    unless ($rem->confirmed()) {
        $self->model->confirm_reminder($rem);
        $self->log(join ' ', 'CONFIRM', $zone, $rem->id, $rem->email );
    }
    my %param = (
        reminder => $rem,
    );
    return $self->process_template(
        $is_mobile
            ? 'm/reminder_good_confirm.tt2'
            : 'zones/reminders/good_confirm.html',
        \%param,
    )->finalize;
}

sub delete_reminder_html {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $id   = shift;

    my $rem = $self->model->reminders->by_id($id);
    unless ($rem) {
        $self->log("DELETE_FAIL $zone $id");
        my $resp = $self->process_template(
            'zones/reminders/bad_delete.html'
        );
        $resp->header('Content-Type' => 'text/html; charset=utf8');
        $resp->status(404);
        return $resp->finalize;
    }

    my $template = 'zones/reminders/confirm_delete.html';
    if ($req->parameters->{confirm}) {
        $template = 'zones/reminders/good_delete.html';
        $self->model->delete_reminder($id);
        $self->log("DELETE $zone $id");
    }

    return $self->process_template($template, {
        reminder => $rem,
    })->finalize;
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
        $self->log("TELLAFRIEND_FAIL");
    }
    elsif ($email_str and $sender_email) {
        my @emails = split qr/\s*,?\s+/, $email_str;
        
        for my $email (@emails) {
            $self->model->mailer->send_email(
                to => $email,
                from => $sender_email,
                subject => "Meet the Vancouver Garbage Reminder system",
                template => 'tell-a-friend.html',
                template_args => {
                    friend_email => $sender_email,
                    base => $self->config->base_url,
                    request_uri => $self->request->request_uri,
                },
            );
        }

        $tmpl_params->{success} = "Email sent.  Thanks!";
        $self->log("TELLAFRIEND " . scalar(@emails));
    }
    
    return $self->process_template('tell-a-friend.tt2', $tmpl_params)->finalize;
}

sub handle_paypal_ipn {
    my $self = shift;
    my $req = $self->request;

    my $ipn = $self->paypal->process_ipn($req);

    if (my $reminder_id = $ipn->rp_invoice_id) {
        my $rem = $self->model->reminders->by_id($reminder_id);
        unless ($rem) {
            $self->log("PAYMENT_IPN for invalid reminder: $reminder_id");
            return $self->ok;
        }
        $self->log("PAYMENT_IPN - $reminder_id");

        given ($ipn->txn_type) {
            when ('recurring_payment_profile_created') {
                $self->_handle_created_ipn($ipn, $rem);
            }
            when ('recurring_payment') {
                $self->log("PAYMENT_RECURRING - $reminder_id - \$"
                            . $ipn->amount);
                $self->_advance_expiry($rem);
            }
            when ('recurring_payment_profile_cancel') {
                $self->_handle_cancel_ipn($ipn, $rem);
            }
            when ('recurring_payment_expired') {
                $self->log("PAYMENT_EXPIRED - $reminder_id - payment_cycle:"
                    . $ipn->payment_cycle);
            }
            default {
                my $ps = $ipn->payment_status;
                if ($ps and $ps eq 'Refunded') {
                    $self->log("PAYMENT_REFUND - $reminder_id - \$"
                                . $ipn->mc_gross);
                }
                else {
                    # Not sure how to handle this IPN
                    $self->log("UNKNOWN_IPN - IPN unknown type - $reminder_id");
                    $self->_log_unknown_ipn($ipn, $reminder_id, "unknown ipn type");
                }
            }
        }
    }
    else {
        # Probably a stray reminder from before they were set up properly, so
        # just log it.
        $self->log("Payment without a rp_invoice_id, ignoring");
    }

    return $self->ok;
}

sub _log_unknown_ipn {
    my $self = shift;
    my $ipn = shift;
    my $reminder_id = shift;
    my $msg = shift || 'unknown error';
    
    my $dump_str = Dumper $ipn->dump(undef, 2);
    eval {
        my $addr = Recollect::Config->Value('errors_to_email')
                    || 'paypal-problem@recollect.net';
        $self->model->mailer->send_email(
            to => $addr,
            subject => "Paypal IPN problem",
            template => 'paypal-problem.html',
            template_args => {
                error_msg => "Unknown paypal txn_type: $msg",
                dump => $dump_str,
            },
        );
    };
    if ($@) {
        $self->log("Error sending UNKNOWN_IPN email ($@) : " . $dump_str);
    }
}

sub _handle_cancel_ipn {
    my $self = shift;
    my $ipn  = shift;
    my $rem  = shift;
    my $reminder_id = $rem->id;

    if ($ipn->profile_status eq 'Cancelled') {
        $self->_cancel_paid_reminder($reminder_id, $rem);
    }
    else {
        $self->log("UNKNOWN_IPN - IPN cancel - $reminder_id");
        $self->_log_unknown_ipn($ipn, $reminder_id, "unknown cancel IPN");
    }

}

sub _advance_expiry {
    my $self = shift;
    my $rem  = shift;

    # Calculate the next expiry, giving an extra week of grace.
    my $new_expiry = DateTime->today + $rem->duration 
                                 + DateTime::Duration->new(weeks => 1);
    if ($new_expiry > $rem->expiry_datetime) {
        $rem->expiry( $new_expiry->epoch );
        $rem->update;
        $self->log("EXPIRY_ADVANCE - " . $rem->id . " - " . $new_expiry->ymd);
    }
}

sub _handle_created_ipn {
    my $self = shift;
    my $ipn  = shift;
    my $rem  = shift;
    my $reminder_id = $rem->id;

    if ($ipn->profile_status eq 'Active' or 
            $ipn->payment_status eq 'Completed') {
        my $gross = $ipn->amount || '?.??';
        $self->log("PAYMENT_PROFILE_CREATED - $reminder_id - \$$gross");
        $self->_advance_expiry($rem);
        return;
    }
    given ($ipn->payment_status) {
        when("Pending") {
            # the payment was made to account, but its status is still pending
            # $ipn->pending() also returns the reason why it is so.
            $self->log("PAYMENT_PENDING - $reminder_id - " . $ipn->pending);
        }
        when("Denied") {
            # the payment denied, it should try again.
            $self->log("PAYMENT_DENIED - $reminder_id");
        }
        when("Failed") {
            # the payment failed. We should delete this reminder?
            $self->_cancel_paid_reminder($reminder_id, $rem);
        }
        default {
            $self->log("UNKNOWN_IPN - IPN create - $reminder_id");
            $self->_log_unknown_ipn($ipn, $reminder_id, "unknown created ipn");
        }
    }
}

sub _cancel_paid_reminder {
    my $self = shift;
    my $reminder_id = shift;
    my $rem = shift;

    $self->log("PAYMENT_FAILED - " . $rem->id);
    $self->model->delete_reminder($rem->id);
    $self->log("DELETE " . $rem->zone . " " . $rem->id);

    $self->mailer->send_email(
        to => $rem->email,
        subject => 'Recollect reminder has expired',
        template => 'reminder-expiry.html',
        template_args => { },
    );
}

sub _build_paypal { Recollect::Paypal->new( model => shift->model ) }

__PACKAGE__->meta->make_immutable;
1;
