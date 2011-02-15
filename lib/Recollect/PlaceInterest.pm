package Recollect::PlaceInterest;
use Moose;
use namespace::clean -except => 'meta';

has 'place' => (is => 'ro', isa => 'Str', required => 1);
has 'date'  => (is => 'ro', isa => 'Str', required => 1);

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

my $valid_point = qr/^-?\d+\.\d+ -?\d+\.\d+$/;
sub Increment {
    my $class = shift;
    my $place = shift;
    return unless $place =~ $valid_point;

    $class->run_sql(
        "INSERT INTO place_interest VALUES ('now'::timestamptz, ?)",
        ["POINT($place)"],
    );
    $class->log("Registered interest in <$place>");
}

sub Notify {
    my $class = shift;
    my $place = shift;
    my $email = shift;
    unless ($place =~ $valid_point) {
        $class->log("Could not register interest in $place - it is not valid");
        return;
    }

    $class->run_sql(
        "INSERT INTO place_notify VALUES ('now'::timestamptz, ?, ?)",
        [ $email, "POINT($place)" ],
    );
    $class->log("Registered interest in <$place> for <$email>");
}

__PACKAGE__->meta->make_immutable;
1;
