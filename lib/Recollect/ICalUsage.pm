package Recollect::ICalUsage;
use Moose;
use namespace::clean -except => 'meta';

with 'Recollect::Roles::Config';
with 'Recollect::Roles::SQL';
with 'Recollect::Roles::Log';

sub Record {
    my $class = shift;
    my $zone = shift;
    my $ical_id = shift;

    $class->log("ICAL: $ical_id for " . $zone->name . " (" . $zone->id . ")");
    my $sth = $class->dbh->prepare(
        "UPDATE ical_users SET last_get = 'now'::timestamptz
            WHERE ical_id = ? AND zone_id = ?"
    );
    die "Could not prepare query: " .$sth->errstr if $sth->err;
    my $rows = $sth->execute($ical_id, $zone->id);
    die "Could not execute query: " .$sth->errstr if $sth->err;
    return if $rows > 0;

    $class->run_sql(
        "INSERT INTO ical_users (ical_id, zone_id, last_get, created_at)
        VALUES (?,?,'now'::timestamptz, 'now'::timestamptz)",
        [$ical_id, $zone->id]
    );
}


__PACKAGE__->meta->make_immutable;
1;
