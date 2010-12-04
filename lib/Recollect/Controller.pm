package Recollect::Controller;
use Moose;
use Fatal qw/open/;
use Template;
use Recollect::Config;
use Recollect::CallController;
use Recollect::Paypal;
use JSON qw/encode_json decode_json/;
use Recollect::Log;
use Email::Valid;
use Plack::Request;
use Plack::Response;
use Business::PayPal::IPN;
use Data::Dumper;
use feature "switch";
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';

has 'paypal' => (is => 'ro', isa => 'Recollect::Paypal', lazy_build => 1);

use constant Version => 1.7;

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
            [ qr{^/zones$}                          => \&zones_html ],
            [ qr{^/zones\.txt$}                     => \&zones_txt ],
            [ qr{^/zones\.json$}                    => \&zones_json ],
            [ qr{^/zones/($coord),($coord)(.*)?}    => \&zone_at_latlng ],
            [ qr{^/zones/([^./]+)$}                 => \&zone_html ],
            [ qr{^/zones/([^/]+)\.txt$}             => \&zone_txt ],
            [ qr{^/zones/([^/]+)\.json$}            => \&zone_json ],
            [ qr{^/zones/([^/]+)/pickupdays$}       => \&zone_days_html ],
            [ qr{^/zones/([^/]+)/pickupdays\.txt$}  => \&zone_days_txt ],
            [ qr{^/zones/([^/]+)/pickupdays\.json$} => \&zone_days_json ],
            [ qr{^/zones/([^/]+)/pickupdays\.ics$}  => \&zone_days_ical ],
            [ qr{^/zones/([^/]+)/nextpickup$} => \&zone_next_pickup_html ],
            [ qr{^/zones/([^/]+)/nextpickup\.txt$} => 
                    \&zone_next_pickup_txt ],
            [ qr{^/zones/([^/]+)/nextpickup\.json$} =>
                    \&zone_next_pickup_json ],
            [ qr{^/zones/([^/]+)/nextdowchange$} => \&zone_next_dow_change_html ],
            [ qr{^/zones/([^/]+)/nextdowchange\.txt$} => 
                    \&zone_next_dow_change_txt ],
            [ qr{^/zones/([^/]+)/nextdowchange\.json$} =>
                    \&zone_next_dow_change_json ],
            [ qr{^/zones/([^/]+)/reminders/([\w\d-]+)$} =>
                    \&show_reminder ],
            [ qr{^/zones/([^/]+)/reminders/([\w\d-]+)/confirm$} =>
                    \&confirm_reminder ],
            [ qr{^/zones/([^/]+)/reminders/([\w\d-]+)/delete$} => 
                    \&delete_reminder_html ],

            # Billing
            [ qr{^/billing/proceed$} => \&payment_proceed ],
            [ qr{^/billing/cancel$}  => \&payment_cancel ],
        ],

        POST => [
            # Website Actions
            [ qr{^/action/tell-friends$} => \&tell_friends ],

            # Billing
            [ qr{^/billing/ipn$} => \&handle_paypal_ipn ],

            # API
            [ qr{^/zones/([^/]+)/reminders$} => \&post_reminder ],
        ],
        DELETE => [
            [ qr{^/zones/([^/]+)/reminders/(.+)$} => \&delete_reminder ],
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

sub zones_html {
    my $self = shift;
    $self->log("ZONES HTML");

    my %param = (
        zones => $self->model->zones->all,
        zone_uri => "/zones",
    );
    return $self->process_template('zones/zones.html', \%param)->finalize;
}

sub zones_txt {
    my $self = shift;
    $self->log("ZONES TXT");

    my $body = join("\n", map { $_->{name} } @{ $self->model->zones->all });
    return $self->response('text/plain' => $body);
}

sub zones_json {
    my $self = shift;
    $self->log("ZONES JSON");

    my $body = encode_json $self->model->zones->all;
    return $self->response('application/json' => $body);
}

sub zone_at_latlng {
    my $self = shift;
    my $req  = shift;
    my $lat  = shift;
    my $lng  = shift;
    my $rest = shift || "";

    my $zone = $self->model->kml->find_zone_for_latlng($lat,$lng);
    my $resp = Plack::Response->new;
    if ($zone) {
        $resp->redirect("/zones/$zone$rest", 302);
    }
    else {
        $resp->status(404);
        $resp->body("Sorry, no zone exists at $lat,$lng!");
    }
    return $resp->finalize
}

sub zone_html {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONE $zone HTML");

    my %param = (
        zone => $self->_load_zone($zone),
    );
    return $self->process_template('zones/zone.html', \%param)->finalize;
}

sub zone_txt {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONE $zone TXT");

    my $zone_hash = $self->_load_zone($zone)->to_hash;
    my $body = '';
    for my $key (keys %$zone_hash) {
        $body .= "$key: $zone_hash->{$key}\n";
    }

    return $self->response('text/plain' => $body);
}

sub zone_json {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONE $zone JSON");

    my $body = encode_json $self->_load_zone($zone)->to_hash;
    return $self->response('application/json' => $body);
}

sub zone_days_html {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONEDAYS $zone HTML");

    my %param = (
        zone => $self->_load_zone($zone),
        uri_append => '/pickupdays',
        days => $self->model->days($zone),
        has_ical => 1,
    );
    return $self->process_template('zones/days.html', \%param)->finalize;
}

sub zone_days_txt {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONEDAYS $zone TXT");

    my $body = join "\n", map { $_->{string} } @{ $self->model->days($zone) };
    return $self->response('text/plain' => $body);
}

sub zone_days_json {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONEDAYS $zone JSON");

    my $body = encode_json $self->model->days($zone);
    return $self->response('application/json' => $body);
}

sub zone_days_ical {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONEDAYS $zone ICAL");

    my $body = $self->model->ical($zone);
    return $self->response('text/calendar' => $body);
}

sub zone_next_pickup_html {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $limit =  $req->param('limit');
    $self->log("ZONENEXTPICKUP $zone HTML");

    my %param = (
        zone => $self->_load_zone($zone),
        uri_append => '/nextpickup',
        days => [$self->model->next_pickup($zone, $limit)],
    );
    return $self->process_template('zones/zone_next_pickup.html', \%param)->finalize;
}

sub zone_next_pickup_txt {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $limit =  $req->param('limit');
    $self->log("ZONENEXTPICKUP $zone TXT");

    my $body = join "\n", $self->model->next_pickup($zone, $limit);
    return $self->response('text/plain' => $body);
}

sub zone_next_pickup_json {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $limit =  $req->param('limit');
    $self->log("ZONENEXTPICKUP $zone JSON");

    my $body
        = encode_json { next => [ $self->model->next_pickup($zone, $limit) ] };
    return $self->response('application/json' => $body);
}

sub zone_next_dow_change_html {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONENEXTDOWCHANGE $zone HTML");

    my %param = (
        zone => $zone,
        uri_append => '/nextdowchange',
        $self->model->next_dow_change($zone, 'return datetime'),
    );
    return $self->process_template('zones/zone_next_dow_change.html', \%param)->finalize;
}

sub zone_next_dow_change_txt {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONENEXTDOWCHANGE $zone TXT");

    my %days = $self->model->next_dow_change($zone, 'return datetime');
    my $body = "Last pickup day before change: " . $days{last}->ymd . "\n"
             . "First pickup day on the new schedule: " . $days{first}->ymd . "\n";
    return $self->response('text/plain' => $body);
}

sub zone_next_dow_change_json {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    $self->log("ZONENEXTDOWCHANGE $zone JSON");

    my $body = encode_json {$self->model->next_dow_change($zone)};
    return $self->response('application/json' => $body);
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

sub show_reminder {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $hash = shift;
            
    my $rem = $self->model->reminders->by_id($hash);
    return $self->_400_bad_request("Cannot find reminder $hash") unless $rem;

    my $body = encode_json $rem->to_hash;
    return $self->response('application/json' => $body);
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

sub post_reminder {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    
    my $args = eval { decode_json $req->raw_body };
    return $self->_400_bad_request("Bad JSON") if $@;

    my $addr;
    if ($args->{email}) {
        $addr = Email::Valid->address($args->{email});
    }
    return $self->_400_bad_request("Bad email address") unless $addr;
    return $self->_400_bad_request("name is required") unless $args->{name};
    return $self->_400_bad_request("target is required") unless $args->{target};
    return $self->_400_bad_request("target is unsupported") unless $self->model->reminders->Is_valid_target($args->{target});

    my $payment_required = $self->model->Payment_required_for($args->{target});
    return $self->_400_bad_request("voice/sms reminders require payment period")
        if $payment_required and !$args->{payment_period};

    if (my $coupon = $args->{coupon} and $payment_required) {
        return $self->_400_bad_request("coupons are only valid for annual subscriptions") unless $args->{payment_period} eq 'year';
    }

    my $reminder = eval { 
        $self->model->add_reminder({
            name => $args->{name},
            email => $addr,
            offset => $args->{offset},
            target => $args->{target},
            zone => $zone,
            ($payment_required ? (payment_period => $args->{payment_period}) : ()),
            coupon => $args->{coupon},
        });
    };
    return $self->_400_bad_request($@) if $@;

    $self->log(join ' ', 'ADD', $zone, $reminder->id, $reminder->email, $reminder->target );
    my @headers;
    push @headers, Location => "/zones/$zone/reminders/" . $reminder->id;
    push @headers, 'Content-Type' => 'application/json';

    my $body = "{}";
    if ($payment_required) {
        $body = q|{"payment_url":"| . $reminder->payment_url . q|"}|;
    }
    return Plack::Response->new(201, \@headers, $body)->finalize;
}

sub _remove_slash {
    (my $url = shift) =~ s{/$}{};
    return $url;
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

sub delete_reminder {
    my $self = shift;
    my $req  = shift;
    my $zone = shift;
    my $id   = shift;

    if ($self->model->delete_reminder($id)) {
        $self->log("DELETE $zone $id");
        return Plack::Response->new(204, [], '' )->finalize;
    }

    $self->log("DELETE_FAIL $zone $id");
    return $self->_400_bad_request("Could not delete $id");
}

sub _load_zone {
    my $self = shift;
    my $name = shift;
    return $self->model->zones->by_name( $name );
}

sub handle_paypal_ipn {
    my $self = shift;
    my $req = $self->request;

    my $ipn = $self->paypal->process_ipn($req);

    if (my $reminder_id = $ipn->rp_invoice_id) {
        my $rem = $self->model->reminders->by_id($reminder_id);
        unless ($rem) {
            $self->log("PAYMENT_IPN for invalid reminder: $reminder_id");
            return $self->_quick_200;
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

    return $self->_quick_200;
}

sub _quick_200 {
    return Plack::Response->new(200, ['Content-Type' => 'text/plain'],
            'KTHXBYE')->finalize;
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
