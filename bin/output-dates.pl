#!/usr/bin/perl
use strict;
use warnings;
use Term::ReadKey;
use DateTime;
use DateTime::Format::Pg;
use Getopt::Long;
use JSON;
use autodie;

my %opts = (
    flags => 'XXX',
    utc => '-08',
);
GetOptions( \%opts,
    'start=s',
    'flags=s',
    'utc=s',
    'output=s',
);

my $zone = shift || die "USAGE: $0 <zone>, then use VI hjl keys!";

my $date = DateTime->today;
if (my $s = $opts{start}) {
    $date = DateTime::Format::Pg->parse_datetime($s);
}

ReadMode('cbreak');

$| = 1;

my @pickups;
while (1) {
    print $date->ymd, " - $opts{flags} ?\n";
    my $char = ReadKey( 0 );

    if ($char eq 'j') { # down
        print "Adding " . $date->ymd . " $opts{flags}\n";
        push @pickups, {
            zone => $zone,
            date => $date->ymd . " 07:00:00$opts{utc}",
            flags => $opts{flags},
        };
        $date->add(weeks => 1);
    }
    elsif ($char eq 'h') {
        $date->subtract(days => 1);
    }
    elsif ($char eq 'l') {
        $date->add(days => 1);
    }
    elsif ($char eq 'q') {
        last;
    }
    else {
        print <<EOT;
Help:
  j - add one week
  h - subtract one day
  l - add one day
  q - quit
EOT
        next;
    }

}

Write_the_tron: {
    my $file = $opts{output} || "$zone.tron";
    print "Writing to $file\n";
    open my $fh, ">", $file;
    print $fh encode_json({ tron_version => 1, pickups => \@pickups });
    close $fh;
}

ReadMode(0);
