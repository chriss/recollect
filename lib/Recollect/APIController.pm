package Recollect::APIController;
use feature 'switch';
use Email::Valid;
use Moose;
use Recollect::CallController;
use Recollect::Subscription;
use Recollect::Area;
use Recollect::PlaceInterest;
use Recollect::Trial;
use Recollect::ICalUsage;
use Plack::Request;
use Plack::Response;
use Data::ICal::Entry::Event;
use Data::ICal;
use Date::ICal;
use JSON qw/decode_json/;
use XML::Simple;
use Try::Tiny;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::Recurly';

our $API_Version = 1.0;

sub run {
    my $self = shift;
    my $env = shift;
    my $req = $self->request;
    my $path = $req->path;

    my $wrapper = sub {
        my $sub_name = shift;
        my $resource_type = shift;
        $sub_name .= '_' . $resource_type if $resource_type;
        $self->log("API: $path");
        return $self->$sub_name(@_);
    };

    my $json_wrapper = sub {
        my $sub_name = shift;
        $self->log("API: POST $path");
        return $self->bad_request_text(
            'Only application/json content type is supported', 415)
            unless $req->content_type =~ m/json/;

        my $args = eval { decode_json $req->raw_body };
        return $self->bad_request_json("Could not decode json: $@") if $@;

        return $self->$sub_name($args, @_);
    };

    my $area_wrapper = sub {
        my ($area_id, $resource_type, $sub_name, @other) = @_;
        my $area = Recollect::Area->Resolve($area_id);
        return $self->not_found unless $area;
        return $wrapper->($sub_name, $resource_type, $area, @other);
    };

    my $zone_wrapper = sub {
        my ($area_id, $zone_id, $resource_type, $sub_name) = @_;
        my $area = Recollect::Area->Resolve($area_id);
        my $zone = $area->resolve_zone_id($zone_id);
        return $self->not_found unless $zone;
        return $wrapper->($sub_name, $resource_type, $area, $zone);
    };

    my $coord_rx = qr{[+-]?\d+\.\d+};
    my $ext_rx   = qr{(?:\.(txt|json|kml|tron))?$};
    my $area_rx  = qr{([\w ]+?)};
    my $zone_rx  = qr{([\w\-_]+?)};
    given ($req->method) {
        when ('GET') {
            given ($path) {
                # API Version
                when ('/') { return $wrapper->('api_version') }
                when (qr{^/version$ext_rx}) {
                    return $wrapper->('api_version', $1);
                }

                # Areas Collection
                when (qr{^/areas$ext_rx}) {
                    return $wrapper->('areas', $1)
                }

                # Area Resource
                when (m{^/areas/$area_rx$ext_rx}) {
                    return $area_wrapper->($1, $2, 'area')
                }

                # Zones Collection
                when (m{^/areas/$area_rx/zones$ext_rx}) {
                    return $area_wrapper->($1, $2, 'zones')
                }

                # Zone Resource
                when (m{^/areas/$area_rx/zones/$zone_rx$ext_rx}) {
                    return $zone_wrapper->($1, $2, $3, 'zone')
                }

                # Zone Pickupdays Collection
                when (m{^/areas/$area_rx/zones/$zone_rx/pickupdays$ext_rx}) {
                    return $zone_wrapper->($1, $2, $3, 'pickupdays')
                }

                # Zone Pickupdays Collection as iCal (RFC 2445)
                when (m{^/areas/$area_rx/zones/$zone_rx/pickupdays\.ics$}) {
                    return $zone_wrapper->($1, $2, $3, 'pickupdays_ical')
                }

                # Zone Next Pickup
                when (m{^/areas/$area_rx/zones/$zone_rx/nextpickup$ext_rx$}) {
                    return $zone_wrapper->($1, $2, $3, 'next_pickup')
                }

                # Zone Next DOW Change
                when (m{^/areas/$area_rx/zones/$zone_rx/nextdowchange$ext_rx$}) {
                    return $zone_wrapper->($1, $2, $3, 'next_dow_change')
                }

                # Zone lookup by lat,lng
                when (m{^/lookup/($coord_rx),($coord_rx)(.*)$}) {
                    return $wrapper->('zone_at_latlng', undef, $1, $2, $3);
                }
                # Zone lookup by lat,lng
                when (m{^/lookup/([\w-]+)(.*)$}) {
                    return $wrapper->('zone_by_name', undef, $1, $2);
                }

                when (m{^/reports/subscriptions_by_area\.json$}) {
                    return $wrapper->('report_subs_by_area', $1)
                }
            }
        }
        when ('POST') {
            given ($path) {
                when ('/areas') { return $json_wrapper->('POST_areas') }
                when ('/subscriptions') {
                    return $json_wrapper->('subscriptions')
                }
                when ('/billing') { return $wrapper->('billing') }
                when (m{^/interest/([^\/]+)/notify$}) {
                    return $wrapper->('request_place_notification', undef, $1);
                }
                when (m{^/areas/$area_rx/zones/$zone_rx/trial}) {
                    return $zone_wrapper->($1, $2, $3, 'trial')
                }

            }
        }
        when ('DELETE') {
            given ($path) {
                when (qr#^/subscriptions/([\w-]+)$#) {
                    return $wrapper->('delete_subscription', undef, $1);
                }
            }
        }
        default {
        }
    }
    return $self->not_found;
}

around 'process_template' => sub {
    my $orig = shift;
    my $self = shift;
    my $template = shift;

    $template = "api/$template" unless $template =~ m/^\d+.tt2$/;
    $orig->($self, $template, @_)->finalize;
};

sub subscriptions {
    my $self = shift;
    my $args = shift;
    my $req  = $self->request;

    my %new_sub = (
        location => $args->{location},
    );
    if (my $email = $args->{email}) {
        if (Email::Valid->address($email)) {
            $new_sub{email} = $email;
        }
        else { return $self->bad_request_json('Bad email address') }
    }
    else { return $self->bad_request_json('Missing email address') }

    my $reminders = $args->{reminders};
    unless ($reminders and ref($reminders) eq 'ARRAY' and @$reminders) {
        return $self->bad_request_json('reminders missing or not an array');
    }
    for my $r (@{ $reminders }) {
        return $self->bad_request_json('Reminders must be a hash')
            unless ref($r) eq 'HASH';
        if (my $zone_id = $r->{zone_id}) {
            my $zone = eval { Recollect::Zone->By_id($zone_id) }
                            || Recollect::Zone->By_name($zone_id);
            return $self->bad_request_json("Invalid zone_id: $zone_id")
                unless $zone;
            $r->{zone_id} = $zone->id;
        }
        else { return $self->bad_request_json('Missing zone_id') }

        if (my $target = $r->{target}) {
            if (!Recollect::Reminder->Is_valid_target($target)) {
                return $self->bad_request_json("target ($target) is unsupported");
            }
        }
        else { return $self->bad_request_json('Missing target') }

        my $offset = $r->{delivery_offset};
        if (defined $offset) {
            unless ($offset =~ m/^-?\d\d?(?::\d\d)*$/) {
                return $self->bad_request_json(
                    'Invalid delivery_offset - format: HH:MM:SS');
            }
            if ($offset =~ m/^-?\d+$/) {
                $r->{delivery_offset} .= ':00';
            }
        }
        else {
            return $self->bad_request_json(
                'Missing delivery_offset - format: HH:MM:SS');
        }
    }
    $new_sub{reminders} = $reminders;

    my $payment_required = !Recollect::Subscription->Is_free($reminders);
    if ($payment_required) {
        my $period = $args->{payment_period};
        return $self->bad_request_json('payment_period is required')
            unless $period;
        return $self->bad_request_json('payment_period must be quarterly or annual')
            unless $period =~ m/^(quarterly|annual)$/;
        $new_sub{payment_period} = $period;
    }
    my $subscr = eval { Recollect::Subscription->Create(%new_sub) };
    return $self->bad_request_json($@) if $@;

    my @headers;
    push @headers, Location => $subscr->url;
    push @headers, 'Content-Type' => 'application/json';

    my $response = $subscr->to_hash;
    $response->{payment_url} = $subscr->payment_url if $payment_required;
    return $self->process_json($response, 201);
}

sub delete_subscription {
    my $self   = shift;
    my $sub_id = shift;
    my $req    = $self->request;

    my $sub = Recollect::Subscription->By_id($sub_id);
    return $self->not_found unless $sub;

    $sub->delete;
    $self->log("Deleted subscription $sub_id");
    return $self->no_content;
}


sub billing {
    my $self = shift;
    my $req  = $self->request;
    return $self->bad_request_text(
        'Only application/xml content type is supported', 415)
        unless $req->content_type eq 'application/xml';
    my $args = eval { XMLin($req->raw_body, KeepRoot => 1) };
    if ($@) {
        warn "Could not parse billing notification XML: $@";
        return $self->bad_request("Could not parse the XML: $@");
    }
    my ($type, $data) = %$args;

    my $acct_id = $data->{account}{account_code};
    my $subscr = Recollect::Subscription->By_id($acct_id);
    unless ($subscr) {
        # If we can't find a subscription then log it and pretend we're cool.
        warn "Billing error - could not find subscription with id: $acct_id";
        return $self->ok;
    }

    given ($type) {
        when (m/^\w+_subscription_notification$/) {
            $self->_update_subscription_state($subscr);
        }
        when ('reactivated_account_notification') {
            $self->_update_subscription_state($subscr);
        }
        when ('new_account_notification') {
            # No action needed
        }
        default {
            $self->log("Unknown billing notification: $type");
        }
    }
    return $self->response('text/plain', 'KTHX');
}

sub _update_subscription_state {
    my $self = shift;
    my $subscr = shift;

    my $id = $subscr->id;
    my $r_subscr = $self->recurly->get_subscription($id);

    if ($r_subscr) {
        given ($r_subscr->{state}) {
            when ('canceled') {
                $subscr->mark_as_inactive;
            }
            when ('active') {
                $subscr->mark_as_active;
            }
            default {
                warn "Unknown subscription state for $id: $r_subscr->{state}";
            }
        }
    }
    else {
        # Subscription has expired
        $subscr->delete;
    }
}

sub _api_version_data {
    return {
        details => [
            { name => 'API Version', value => $API_Version },
        ]
    };
}

sub api_version {
    my $self = shift;
    return $self->process_template('version.html', $self->_api_version_data);
}

sub api_version_json {
    my $self = shift;
    return $self->process_json($self->_api_version_data->{details});
}

sub api_version_txt {
    my $self = shift;
    return $self->process_template('version.txt', $self->_api_version_data);
}


sub _areas_data {
    return {
        areas => Recollect::Area->All,
    };
}

sub POST_areas {
    my $self = shift;
    my $args = shift;
    return $self->forbidden unless $self->user_is_admin;

    my $area = Recollect::Area->Create(
        map { $_ => $args->{$_} }
            qw/name ad_img ad_url licence_url/
    );

    my $response = $area->to_hash;
    return $self->process_json($response, 201);
}

sub areas {
    my $self = shift;
    return $self->process_template('areas.html', $self->_areas_data);
}

sub areas_json {
    my $self = shift;
    return $self->process_json(
        [ map { $_->to_hash } @{ $self->_areas_data->{areas} } ]
    );
}

sub areas_txt {
    my $self = shift;
    return $self->process_template('areas.txt', $self->_areas_data);
}

sub area {
    my $self = shift;
    my $area = shift;
    return $self->process_template('area.html',
        { has_kml => 1, area => $area });
}

sub area_json {
    my $self = shift;
    my $area = shift;
    return $self->process_json( $area->to_hash );
}

sub area_tron {
    my $self = shift;
    my $area = shift;

    my @zones;
    my @pickups;
    for my $zone (@{ $area->zones }) {
        my $ztron = $zone->as_tron;
        push @zones, @{ $ztron->{zones} };
        push @pickups, @{ $ztron->{pickups} };
    }

    my $tron = {
        tron_version => 1,
        zones => \@zones,
        pickups => \@pickups,
    };
    return $self->process_json($tron);
}

sub area_txt {
    my $self = shift;
    my $area = shift;
    return $self->process_template('area.txt', { area => $area });
}

sub area_kml {
    my ($self, $area, $zone) = @_;
    return $self->process_template( 'kml.xml', {
            name     => "Recollect Collection Area - " . $area->title,
            styles   => $area->styles,
            polygons => $area->polygons,
        }
    );
}

sub zones {
    my $self = shift;
    my $area = shift;
    return $self->process_template('zones.html', { area => $area });
}

sub zones_json {
    my $self = shift;
    my $area = shift;
    return $self->process_json([ map { $_->to_hash } @{ $area->zones } ]);
}

sub zones_txt {
    my $self = shift;
    my $area = shift;
    return $self->process_template('zones.txt', { zones => $area->zones });
}

sub zone {
    my ($self, $area, $zone) = @_;
    return $self->process_template('zone.html',
        { has_kml => 1, area => $area, zone => $zone });
}

sub zone_json {
    my ($self, $area, $zone) = @_;
    return $self->process_json($zone->to_hash);
}

sub zone_tron {
    my ($self, $area, $zone) = @_;
    return $self->process_json($zone->as_tron);
}

sub zone_txt {
    my ($self, $area, $zone) = @_;
    return $self->process_template('zone.txt',
        { area => $area, zone => $zone });
}

sub zone_kml {
    my ($self, $area, $zone) = @_;
    return $self->process_template( 'kml.xml', {
            name     => "Recollect Collection Zone - " . $zone->title,
            styles   => [ $zone->style ],
            polygons => $zone->polygons,
        }
    );
}

sub trial {
    my ($self, $area, $zone) = @_;
    my $target = $self->request->parameters->{target};

    if (!Recollect::Trial->Is_valid_target($target)) {
        return $self->bad_request("target:$target is unsupported");
    }

    if (my $t = Recollect::Trial->Create(zone => $zone, target => $target)) {
        $t->fire;
        return $self->no_content;
    }

    return $self->forbidden;
}

sub pickupdays {
    my ($self, $area, $zone) = @_;
    return $self->process_template('pickupdays.html',
        { has_ical => 1, area => $area, zone => $zone });
}

sub pickupdays_json {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_json([ map { $_->to_hash } @{ $zone->pickups } ]);
}

sub pickupdays_txt {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_template('pickupdays.txt',
        { area => $area, zone => $zone });
}

sub pickupdays_ical {
    my $self = shift;
    my $area = shift;
    my $zone = shift;

    my $ical = Data::ICal->new;
    for my $pickup (@{ $zone->pickups }) {
        my $evt = Data::ICal::Entry::Event->new;
        $evt->add_properties(
            summary => "Recollect - " . $pickup->flags_desc,
            dtstart => $pickup->ymd(''),
        );
        $ical->add_entry($evt);
    }


    try {
        my $t = $self->request->param("t") || 0;
        Recollect::ICalUsage->Record($zone, $t);
    }
    catch { warn "Error recording Ical usage: $_\n" };

    return $self->response('text/calendar', $ical->as_string);
}

sub _next_pickups {
    my $self = shift;
    my $zone = shift;
    my $limit = $self->request->param('limit');
    return $zone->next_pickup($limit);
}

sub next_pickup {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_template('next_pickup.html',
        { area => $area, zone => $zone, pickups => $self->_next_pickups($zone) });
}

sub next_pickup_json {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_json([ map { $_->to_hash } @{ $self->_next_pickups($zone) } ]);
}

sub next_pickup_txt {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_text(join "\n", map { $_->string } @{ $self->_next_pickups($zone) });
}

sub next_dow_change {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_template('next_dow_change.html',
        { area => $area, zone => $zone, %{ $zone->next_dow_change } });
}

sub next_dow_change_json {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    my $days = $zone->next_dow_change;
    return $self->process_json( {
            last => $days->{last}->to_hash,
            next => $days->{next}->to_hash,
        }
    );
}

sub next_dow_change_txt {
    my $self = shift;
    my $area = shift;
    my $zone = shift;
    return $self->process_text($zone->next_dow_change->{next}->string);
}


sub zone_at_latlng {
    my $self = shift;
    my $req  = $self->request;
    my $lat  = shift;
    my $lng  = shift;
    my $rest = shift || '';

    my $resp = Plack::Response->new;
    if (my $zone = Recollect::Zone->By_latlng($lat, $lng)) {
        my $area_name = $zone->area->name;
        my $zone_name = $zone->name;
        $resp->redirect("/api/areas/$area_name/zones/$zone_name$rest", 302);
    }
    else {
        $resp->status(404);
        $resp->body("Sorry, no zone exists at $lat,$lng!");
    }
    return $resp->finalize;
}

sub zone_by_name {
    my $self = shift;
    my $req  = $self->request;
    my $name = shift;
    my $rest = shift || '';

    my $resp = Plack::Response->new;
    if (my $zone = Recollect::Zone->By_name($name)) {
        my $area_name = $zone->area->name;
        my $zone_name = $zone->name;
        $resp->redirect("/api/areas/$area_name/zones/$zone_name$rest", 302);
    }
    else {
        $resp->status(404);
        $resp->body("Sorry, no zone exists with name: $name");
    }
    return $resp->finalize;
}

sub _place_is_ok { defined $_[0] and length $_[0] and length $_[0] < 30 }

sub request_place_notification {
    my $self = shift;
    my $place = shift || 'noplace';
    my $email = $self->request->parameters->{email} || '';

    if ($email and _place_is_ok($place) and Email::Valid->address($email)) {
        $place =~ s/,/ /;
        eval { Recollect::PlaceInterest->Notify($place, $email) };
        $self->log("Couldn't register interest in ($place, $email): $@") if $@;
    }
    else {
        $self->log("Couldn't register interest for ($place, $email)");
    }
    return $self->no_content;
}

sub report_subs_by_area {
    my $self = shift;
    my $args = shift;

    my $response = {
        item => [
            {
                value => 10,
                label => 'Toronto',
            },
            {
                value => 20,
                label => 'Edmonton',
            },
            {
                value => 30,
                label => 'Vancouver',
            },

        ],
    };
    return $self->process_json($response, 201);
}

__PACKAGE__->meta->make_immutable;
1;
