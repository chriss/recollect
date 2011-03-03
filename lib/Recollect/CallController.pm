package Recollect::CallController;
use Moose;
use Email::MIME;
use Plack::Response;
use Recollect::Zone;
use namespace::clean -except => 'meta';

with 'Recollect::ControllerBase';
with 'Recollect::Roles::Email';

sub run {
    my $self = shift;
    my $req = $self->request;
    my $path = $req->path;

    my @func_map = (
        [ qr{^/start$}       => \&start ],
        [ qr{^/show/main$}   => \&show_main_menu ],
        [ qr{^/gather/main$} => \&process_main_menu ],

        [ qr{^/show/lookup_menu$}              => \&show_lookup_menu ],
        [ qr{^/gather/lookup$}                 => \&process_region ],
        [ qr{^/show/zones_menu/(north|south)$} => \&show_zones_menu ],
        [ qr{^/gather/lookup/(north|south)$}   => \&lookup_zone ],

        [ qr{^/notify/([\w-]+)$}     => \&voice_notify ],
        [ qr{^/notify/([\w-]+)/status$} => \&voice_notify_status ],
        [ qr{^/show/message_prompt$} => \&show_message_prompt ],
        [ qr{^/receive/message$}     => \&receive_voicemail ],
        [ qr{^/goodbye$}             => \&goodbye ],

        [ qr{^/sms/receive$}         => \&receive_sms ],
    );

    my $response = '';
    for my $match (@func_map) {
        my ($regex, $callback) = @$match;
        if ($path =~ $regex) {
            $response = $callback->($self, $req, $1, $2, $3, $4);
            last;
        }
    }

    my $resp = Plack::Response->new(200);
    $resp->header('Content-Type' => 'text/xml');
    $resp->header('Cache-Control' => 'no-cache, no-store, must-revalidate');
    $response ||= "<Say voice=\"woman\">I'm sorry.  Lets start at the beginning.</Say>"
            . "<Redirect>/call/start</Redirect>";

    my $body = <<EOT;
<?xml version="1.0" encoding="UTF-8"?>
<Response>
$response
</Response>
EOT
    $resp->body($body);

    return $resp->finalize;
}

sub start { 
    my $self = shift;
    $self->log("New inbound call");
    return <<EOT;
        <Say voice="woman">
            Hello, you have reached the recollect dot net phone service.  
        </Say>
        <Redirect>/call/show/main</Redirect>
EOT
}

sub show_main_menu {
    return <<EOT;
    <Gather action="/call/gather/main" method="POST" numDigits="1" timeout="7">
        <Say voice="woman">
            To look up the garbage day, press 1.
            To leave a message telling us how much you love recollect dot net, press 2.
        </Say>
    </Gather>
    <Say voice="woman">Lets try that again.</Say>
    <Redirect>/call/show/main</Redirect>
EOT
}

sub process_main_menu {
    my ($self, $req, @args) = @_;

    my $num = $req->parameters->{Digits};
    if ($num and $num =~ m/^[12]$/) {
        if ($num == 1) {
            return '<Redirect>/call/show/lookup_menu</Redirect>';
        }
        elsif ($num == 2) {
            return '<Redirect>/call/show/message_prompt</Redirect>';
        }
    }
    return "<Say voice=\"woman\">Please choose one or two.</Say>"
        . "<Redirect>/call/show/main</Redirect>";
}

sub show_lookup_menu { 
    return <<EOT;
<Gather action="/call/gather/lookup" method="POST" numDigits="1" timeout="7">
    <Say voice="woman">
        Which zone would you like to know the schedule for?
        For Vancouver North zones, press 1.
        For Vancouver South zones, press 2.
    </Say>
    <Pause length="2"/>
    <Say voice="woman">
      If you are not sure which zone you live in, go to our website at: recollect dot net.
    </Say>
</Gather>
<Say voice="woman">Lets try that again.</Say>
<Redirect>/call/show/lookup_menu</Redirect>
EOT
}

sub show_message_prompt {
    return <<EOT;
   <Say voice="woman">
     Please leave your message for Recollect. 
     Press pound or hang up when you are done.
   </Say>
   <Record action="/call/goodbye" method="POST" finishOnKey="#" maxLength="120"
    transcribe="true" transcribeCallback="/call/receive/message" />
   <Say voice="woman">Thank you.</Say>
   <Say voice="man">Thank you.</Say>
   <Hangup/>
EOT
}
sub process_region {
    my ($self, $req, @args) = @_;

    my $num = $req->parameters->{Digits};
    if ($num and $num =~ m/^[12]$/) {
        my $type = $num == 1 ? 'north' : 'south';
        return "<Redirect>/call/show/zones_menu/$type</Redirect>";
    }
    return "<Say voice=\"woman\">Please choose one or two.</Say>"
        . "<Redirect>/call/show/main</Redirect>";
}

sub voice_notify {
    my ($self, $req, $zone_name) = @_;
    $self->log("Voice call for zone $zone_name");

    my $zone = Recollect::Zone->By_name($zone_name) or return;
    my $pickup = $zone->next_pickup->[0];
    my $day_name = $pickup->datetime->day_name;

    my $lang = $req->parameters->{lang} || 'en';
    if (my $recording = $self->_find_recording($lang, $pickup, $day_name)) {
        return <<EOT;
<Pause length="1"/>
<Play>/audio/$recording</Play>
<Hangup/>
EOT
    }


    my $extra;
    my $items = $pickup->flag_names;
    if (@$items == 1) {
        $extra = $items->[0];
    }
    else {
        my $last = pop @$items;
        $extra = join(', ', @$items) . " and $last";
    }
    $extra .= ' will be picked up.';

    return <<EOT;
<Pause length="1"/>
<Say voice="woman">
Hello, this is Recollect, your garbage reminder service. 
Your next pickup day is $day_name. 
$extra.
Goodbye!
</Say>
<Hangup/>
EOT
}

sub _find_recording {
    my $self = shift;
    my $lang = shift;
    my $pickup = shift;
    my $day_name = shift;

    if ($lang eq 'luke') {
        if ($pickup->has_flag('Y')) {
        }
        else {
        }
    }

    return undef;
}

sub voice_notify_status {
    my ($self, $req, $zone_name) = @_;

    warn "StatusCallback";
    return <<EOT
<Hangup />
EOT
}

sub show_zones_menu {
    my ($self, $req, $type) = @_;
    return <<EOT;
<Gather action="/call/gather/lookup/$type" method="POST" numDigits="1" timeout="7">
    <Say voice="woman">
        For the red $type zone, press 1.
        For blue $type, press 2.
        For green $type, press 3.
        For purple $type, press 4.
        And for yellow $type, press 5.
    </Say>
</Gather>
<Say voice="woman">Lets try that again.</Say>
<Redirect>/call/show/zones_menu/$type</Redirect>
EOT
}

sub lookup_zone {
    my ($self, $req, @args) = @_;
    my $type   = $args[0];

    my $num = $req->parameters->{Digits};
    if ($num and $num =~ m/^[12345]$/) {
        my @zones = (undef, qw/red blue green purple yellow/);
        my $zone_name = "vancouver-$type-$zones[$num]";
        my $zone = Recollect::Zone->By_name($zone_name);
        my $d = $zone->next_pickup->[0];
        my $nice_date = $d->pretty_day;
        my $extra = "No yard trimmings will be picked up.";
        if ($d->has_flag('Y')) {
            $extra = "Yard trimmings and food compost will be picked up.";
        }
        return <<EOT;
    <Say voice="woman">
      The next pickup day for Vancouver $type $zones[$num] is: $nice_date. $extra
    </Say>
    <Pause length="2"/>
    <Say voice="woman">Have a nice day.</Say>
    <Hangup/>
EOT
    }
    return "<Say voice=\"woman\">Please choose one of the zones.</Say>"
        . "<Redirect>/call/show/zones_menu/$type</Redirect>";
}

sub receive_voicemail {
    my ($self, $req, @args) = @_;
    my $params = $req->parameters;

    $self->log("Received voicemail");
    my $body = "A new voicemail is available at: $params->{RecordingUrl}\n\n";
    if ($params->{TranscriptionStatus} eq 'completed') {
        $body .= "Transcription: $params->{TranscriptionText}\n";
    }
    my %headers = (
        From    => 'Recollect <noreply@recollect.net>',
        To      => 'info@recollect.net',
        Subject => "New Recollect voicemail message",
    );
    my $email = Email::MIME->create(
        attributes => {
            content_type => 'text/plain',
            disposition  => 'inline',
            charset      => 'utf8',
        },
        body => $body,
    );
    $email->header_set($_ => $headers{$_}) for keys %headers;

    $self->send_email($email);
}

sub receive_sms {
    my ($self, $req, @args) = @_;
    my $params = $req->parameters;

    $self->log("Received SMS from ($params->{From}): $params->{Body}");
    my $body = "A sms message was received: '$params->{Body}' from "
             . "$params->{From}.";
    my %headers = (
        From    => 'Recollect <noreply@recollect.net>',
        To      => 'team@recollect.net',
        Subject => "New SMS received from $params->{From}",
    );
    my $email = Email::MIME->create(
        attributes => {
            content_type => 'text/plain',
            disposition  => 'inline',
            charset      => 'utf8',
        },
        body => $body,
    );
    $email->header_set($_ => $headers{$_}) for keys %headers;
    $self->send_email($email);
    return "<Hangup/>";
}

sub goodbye { "<Say voice=\"woman\">Goodbye.</Say><Hangup/>" }

__PACKAGE__->meta->make_immutable;
1;
