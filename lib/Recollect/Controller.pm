package Recollect::Controller;
use feature 'switch';
use Moose;
use Fatal qw/open/;
use Template;
use Recollect::CallController;
use Recollect::Subscription;
use Recollect::Zone;
use Recollect::Area;
use JSON qw/encode_json decode_json/;
use Email::Valid;
use Plack::Request;
use Plack::Response;
use Data::Dumper;
use HTML::Calendar::Simple;
use Try::Tiny;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::Email';
with 'Recollect::Roles::SQL';

sub run {
    my $self = shift;
    my $env = shift;
    my $req = $self->request;

    my $coord = qr{[+-]?\d+\.\d+};

    my $path = $req->path;
    my %func_map = (
        GET => [
            [ qr{^/$}           => \&ui_html ], # Landing page
            [ qr{^/(r/.*)?$}    => \&ui_html ], # HTML5 wizard
            [ qr{^/(m/.+)}      => \&ui_html ], # Mobile wizard
            [ qr{^/(.+)\.html$} => \&ui_html ], # Rendered pages
            [ qr{^/([\w-]+)$}   => \&ui_html ], # Same, but make the .html optional

            # Delete subscription link confirmation page:
            [ qr{^/subscription/delete/([\w-]+)$} => \&delete_subscription_page ],
            # Payment success / cancel page
            [ qr{^/payment/([^/]+)/(.+)$} => \&payment_ui ],
            # Full-page schedule view
            [ qr{^/schedule/(.+)$} => \&schedule ],
            # Area Ad redirect
            [ qr{^/adclick/([\w\s]+)$} => \&ad_click ],
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
    my $params = $req->parameters;
    $params->{host_port} = $req->uri->host_port;
    $params->{twitter} = $self->config->{twitter_username};
    $params->{analytics_id} = $self->config->{analytics_id};

    my $areas = Recollect::Area->All;

    # NoScript functionality
    if ($tmpl =~ m{^r/(.+)$}) {
        undef $tmpl; # Use the default template
        $params->{zone} = Recollect::Zone->By_name($1);
        if ($params->{zone}) {
            $params->{pickups} = eval {
                $params->{zone}->next_pickup(4);
            } || [];
        }
    }
    else {
        # Load areas and zones for NoScript
        $params->{areas} = $areas;
        if (my $zone_name = $params->{zone}) {
            return $self->redirect("/r/$zone_name");
        }
        elsif (my $area_name = $params->{area}) {
            my $area = Recollect::Area->By_name($area_name);
            $params->{zones} = Recollect::Zone->By_area_id($area->id);
        }
    }

    $params->{keywords} = [
        'garbage day', 'garbage reminder', 'recycling day',
        map { lc($_->name) } @$areas,
    ];

    if (my $ah = $self->area_hostname) {
        $params->{area} = Recollect::Area->By_name($ah);
    }

    return $self->redirect('/m/index') if $self->is_mobile($req) and !$tmpl;

    $tmpl ||= $self->default_page($req);
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
            my $area = $sub->areas->[0];
            return $self->redirect("/r/success/" . $area->name);
        }
        when ('cancel') {
            $self->log("PAYMENT_CANCEL - $id - " . $sub->user->email);
            $sub->delete;
        }
    }
    return $self->redirect("/");
}

sub schedule {
    my $self = shift;
    my $req  = shift;
    my $zone_name = shift;

    my $zone = Recollect::Zone->By_name($zone_name);
    return $self->redirect('/') unless $zone;

    my %months;
    for my $p (@{ $zone->pickups }) {
        my $sort = sprintf('%d-%02d', $p->datetime->year, $p->datetime->month);
        my $cal = $months{$sort} ||= {
            month => $p->datetime->month,
            calendar => HTML::Calendar::Simple->new({
                year => $p->datetime->year,
                month => $p->datetime->month,
            }),
        };
        $cal->{calendar}->daily_info({
                day => $p->datetime->day,
                text => $p->flags,
            },
        );
    }

    my @months;
    for my $m (sort keys %months) {
        push @months, {
            month => $months{$m}->{month},
            html => $months{$m}->{calendar}->calendar_month,
        }
    }


    $self->log("SCHEDULE - $zone_name");
    return $self->process_template("schedule.tt2", {
            zone => $zone,
            months => \@months,
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
        $self->log("TELLAFRIEND_FAIL - skilltest");
    }
    elsif ($email_str and $sender_email) {
        my @emails = split qr/\s*,?\s+/, $email_str;
        
        for my $email (@emails) {
            $self->send_email(
                to => $email,
                from => $sender_email,
                subject => "Meet Recollect - the Garbage and Recycling Reminder Service",
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

sub ad_click {
    my $self = shift;
    my $req  = shift;
    my $area_name = shift;

    my $area = Recollect::Area->By_name($area_name);
    return $self->redirect('/') unless $area;

    try {
        $self->run_sql(
            'INSERT INTO ad_clicks (area_id) VALUES (?)',
            [ $area->id ],
        );
    }
    catch { warn "Error recording ad_click: $_\n" };
    return $self->redirect( $area->ad_url );
}

__PACKAGE__->meta->make_immutable;
1;
