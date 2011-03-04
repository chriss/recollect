#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Recollect::Scraper;
use Recollect::Area;
use Getopt::Long;

my $zone = shift;
my $area = Recollect::Area->By_name('Vancouver');
unless ($area) {
    warn "Adding Vancouver area\n";
    $area = Recollect::Area->Create(
        name => 'Vancouver',
        centre => '49.26422,-123.138542',
    );
    for my $ns (qw/north south/) {
        for my $colour (qw/red green blue yellow purple/) {
            warn "Adding vancouver-$ns-$colour zone\n";
            $area->add_zone(
                name => "vancouver-$ns-$colour",
                title => "Vancouver " . ucfirst($ns) . ' ' . ucfirst($colour),
                colour => $colour,
            );
        }
    }
}

my $scraper = Recollect::Scraper->new(
    ($zone ? (zone => $zone) : ()),
    area => $area,
);
$scraper->scrape;
