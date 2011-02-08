package Recollect::PlaceInterest;
use Moose;
use namespace::clean -except => 'meta';

has 'place' => (is => 'ro', isa => 'Str', required => 1);
has 'date'  => (is => 'ro', isa => 'Str', required => 1);

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

sub _normalize_place {
    my $place = lc(shift || '');
    $place =~ s/^\s+//; $place =~ s/\s+$//; $place =~ s/\s+/ /g;
    return $place;
}

sub Increment {
    my $class = shift;
    my $place = _normalize_place(shift) or return;

    $class->run_sql(
        "INSERT INTO place_interest VALUES ('now'::timestamptz, ?)",
        [$place],
    );
    $class->log("Registered interest in <$place>");
}

sub Notify {
    my $class = shift;
    my $place = _normalize_place(shift) or return;
    my $email = shift;

    $class->run_sql(
        "INSERT INTO place_notify VALUES ('now'::timestamptz, ?, ?)",
        [ $place, $email ],
    );
    $class->log("Registered interest in <$place> for <$email>");
}

__PACKAGE__->meta->make_immutable;
1;
