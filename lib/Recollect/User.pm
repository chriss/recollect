package Recollect::User;
use Moose;
use DateTime::Format::Pg;
use Recollect::Reminder;
use Data::UUID;
use Crypt::Eksblowfish::Bcrypt qw/en_base64/;
use Crypt::Random::Source;
use namespace::clean -except => 'meta';

extends 'Recollect::Collection';
with 'Recollect::Roles::Template';
with 'Recollect::Roles::Email';

has 'id'          => (is => 'ro', isa => 'Str',        required => 1);
has 'email'       => (is => 'ro', isa => 'Str',        required => 1);
has 'created_at'  => (is => 'ro', isa => 'Str',        required => 1);
has 'twittername' => (is => 'ro', isa => 'Maybe[Str]', required => 1);
has 'is_admin'    => (is => 'ro', isa => 'Bool',       required => 1);
has 'passhash'    => (is => 'ro', isa => 'Maybe[Str]');
has 'reset_passhash'     => (is => 'ro', isa => 'Maybe[Str]');
has 'created_date'       => (is => 'ro', isa => 'Object', lazy_build => 1);
has 'subscription_count' => (is => 'ro', isa => 'Num', lazy_build => 1);
has 'reminders' => (
    is         => 'ro', isa => 'ArrayRef[Recollect::Reminder]',
    lazy_build => 1
);
has 'is_area_admin' => (is => 'ro', isa => 'Bool',          lazy_build => 1);
has 'area_admin'    => (is => 'ro', isa => 'Maybe[Object]', lazy_build => 1);

sub All_active {
    my $class = shift;
    my $sth = $class->run_sql(<<EOT, []);
SELECT DISTINCT(u.*) FROM users u
    JOIN subscriptions s ON (s.user_id = u.id)
    WHERE s.active = 't'
    ORDER BY created_at DESC
EOT
    return $class->_all_as_obj($sth);
}

sub _build_subscription_count { die "Not implemented yet" }

sub _build_reminders {
    my $self = shift;

    my $sth = $self->run_sql(<<EOT, [$self->id]);
SELECT r.* FROM reminders r
    JOIN subscriptions s ON (r.subscription_id = s.id)
    JOIN users u ON (s.user_id = u.id)
    WHERE u.id = ?
EOT
    return Recollect::Reminder->_all_as_obj($sth);
}

sub _build_created_date {
    my $self = shift;
    return DateTime::Format::Pg->parse_datetime($self->created_at);
}

sub By_email {
    my $class = shift;
    return $class->By_field('LOWER(email)' => lc shift);
}

sub By_twitter {
    my $class = shift;
    return $class->By_field('LOWER(twittername)' => lc shift);
}

sub By_reset_passhash {
    my $class = shift;
    return $class->By_field('reset_passhash' => shift);
}

sub set_password {
    my $self = shift;
    my $new = shift;

    # Use bcrypt and append with a NULL - The accepted way to do it
    my $method = '$2a';
    # Has to be 2 digits exactly
    my $work_factor = sprintf("%02d", 12);
    # Salt must be exactly 16 octets, base64 encoded.
    my $salt = en_base64( Crypt::Random::Source::get_weak(16) );

    # Create the settings string that we will use to bcrypt the plaintext
    # Read the docs of the Crypt:: modules for an explanation of this string
    my $new_settings = join('$', $method, $work_factor, $salt);
    my $hashed_pass = Crypt::Eksblowfish::Bcrypt::bcrypt($new, $new_settings);

    $self->run_sql("UPDATE users SET passhash = ?, reset_passhash = NULL
                      WHERE id = ?",
        [$hashed_pass, $self->id],
    );
}

sub reset_password {
    my $self = shift;
    return unless $self->is_area_admin;

    my $new_hash = Data::UUID->new->create_str;
    $self->run_sql("UPDATE users SET reset_passhash = ? WHERE id = ?",
        [$new_hash, $self->id]);

    $self->log("Sending password reset email to " . $self->email);
    $self->send_email(
        template => 'password-reset.tt2',
        template_args => {
            hash => $new_hash,
            base_url => $self->base_url,
        },
        to => $self->email,
        subject => "Recollect Password Reset",
        content_type => 'text/html',
    );
}

sub to_hash {
    my $self = shift;
    return {
        email => $self->email,
        created_at => $self->created_at,
    };
}

sub _build_area_admin {
    my $self = shift;
    my $area_id = $self->sql_singlevalue(
        'SELECT area_id FROM area_admins WHERE user_id = ? LIMIT 1', [$self->id],
    );
    return undef unless $area_id;
    return Recollect::Area->By_id($area_id);
}

sub _build_is_area_admin {
    my $self = shift;
    return $self->area_admin ? 1 : 0;
}

__PACKAGE__->meta->make_immutable;
1;
