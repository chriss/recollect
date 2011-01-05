package Recollect::Twilio;
use MooseX::Singleton;
use WWW::Twilio::API;
use URI::Encode qw/uri_encode/;
use namespace::clean -except => 'meta';

has 'api' => (is => 'ro', isa => 'WWW::Twilio::API', lazy_build => 1);

with 'Recollect::Roles::Config';

sub _build_api {
    my $self = shift;

    return WWW::Twilio::API->new(
        API_VERSION => '2010-04-01',
        map { $_ => $self->config->{"twilio_$_"} } qw(AccountSid AuthToken)
    ) or die "Could not create a twilio!";
}

sub send_sms {
    my $self    = shift;
    my $number  = shift;
    my $message = shift;

    return if $number eq '000-000-0000'; # testing number - invalid

    my $response = $self->api->POST(
        'SMS/Messages',
        From => $self->sms_from_number,
        To   => $number,
        Body => $message,
    );
    unless ($response->{code} == 201) {
        (my $comment = $response->{content}) =~ s/.+\<Message\>(.+?)\<\/Message\>.+/$1/;
        die "Could not send SMS to $number: $comment\n";
    }
    warn "Sending text message to $number\n";
}

sub voice_call {
    my $self    = shift;
    my $number  = shift;
    my $path = shift;
    my %opts = @_;

    return if $number eq '000-000-0000'; # testing number - invalid

    my $url = $self->base_url . $path;
    $opts{StatusCallback} = $self->base_url . $opts{StatusCallback}
        if $opts{StatusCallback};

    my $response = $self->api->POST(
        'Calls',
        Caller => $self->voice_from_number,
        Called => $number,
        Url    => $url,
        %opts,
    );
    
    unless ($response->{code} == 201) {
        (my $comment = $response->{content}) =~ s/.+\<Message\>(.+?)\<\/Message\>.+/$1/;
        die "Could not place a call to $number: $comment\n";
    }
    warn "Placing call to $number\n";
}

sub sms_from_number   { shift->_config_value('twilio_from_number_sms') }
sub voice_from_number { shift->_config_value('twilio_from_number_voice') }

sub _config_value {
    my $self = shift;
    my $key  = shift;
    $self->config->{$key} || die "$key must be set in the config file!";
}

__PACKAGE__->meta->make_immutable;
1;
