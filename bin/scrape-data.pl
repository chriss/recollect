#!/usr/bin/perl
use FindBin;
use lib "$FindBin::Bin/../lib";
use Recollect::Scraper;

my $zone = shift;

my $scraper = Recollect::Scraper->new(
    ($zone ? (zone => $zone) : ()),
    area => 'vancouver',
);
$scraper->scrape;

my $dumpfile = "$FindBin::Bin/../data/recollect.dump";
print "Dumping database to $dumpfile\n";
system("echo '.dump' | sqlite3 data/recollect.db > $dumpfile");
