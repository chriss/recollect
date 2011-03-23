#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Recollect::Util;
use Recollect::Area;
use Fatal qw/open rename close/;

my $base_url = Recollect::Util->base_url;

my $output = "$FindBin::Bin/../root/sitemap.xml";
my $temp = "$output.$$";
END { unlink $temp if $temp and -e $temp }

open(my $fh, ">$temp");
print $fh <<EOT;
<?xml version="1.0" encoding="UTF-8"?>
<urlset
      xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9
            http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd">
EOT

for my $uri (calculate_all_uris()) {
    print $fh <<EOT;
<url><loc>$base_url$uri->{loc}</loc><changefreq>$uri->{changefreq}</changefreq></url>
EOT
}
print $fh "</urlset>\n";
close $fh;
rename $temp => $output;
exit;

sub calculate_all_uris {
    my @uris;
    for my $f (glob("$FindBin::Bin/../template/*.tt2")) {
        (my $name = $f) =~ s/.*?([\w-]+)\.tt2$/$1/;
        next if $name =~ m/^\d+$/;
        push @uris, {
            loc => "/$name",
            changefreq => 'daily',
        };
    }

    push @uris, { loc => '/api', changefreq => 'weekly' },
                { loc => '/api/areas', changefreq => 'daily' };

    for my $area (@{ Recollect::Area->All }) {
        my $aname = $area->name;

        for my $zone (@{ $area->zones }) {
            my $zname = $zone->name;
            push @uris, {
                loc => "/r/$zname",
                changefreq => 'daily',
            };
        }
    }
    return @uris;
}
