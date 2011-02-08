package Recollect::PlaceInterest;
use Moose;
use namespace::clean -except => 'meta';

has 'place' => (is => 'ro', isa => 'Str', required => 1);
has 'date'  => (is => 'ro', isa => 'Str', required => 1);

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

sub Increment {
    my $class = shift;
    my $place = lc shift || '';

    # Normalize the whitespace
    $place =~ s/^\s+//; $place =~ s/\s+$//; $place =~ s/\s+/ /g;
    return unless $place;

    eval {
        $class->run_sql("INSERT INTO place_interest VALUES ('now'::timestamptz, ?)",
            [$place]);
    };
    $class->log($@ ? "Error registering interest in '$place': $@"
                   : "Registered interest in <$place>");
}

__PACKAGE__->meta->make_immutable;
1;
