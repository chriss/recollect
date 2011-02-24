#!/usr/bin/perl
use strict;
use warnings;
use Term::ReadKey;
use DateTime;

my $zone = shift || die "USAGE: $0 <zone>, then use VI hjl keys!";

my $date = DateTime->today;
ReadMode('cbreak');

$| = 1;

while (1) {
    warn $date->ymd . "\n";
    my $char = ReadKey( 0 );

    if ($char eq 'j') { # down
        print $zone . ',' . $date->ymd . "\n";
        warn "\t" . $zone . ',' . $date->ymd . "\n";
        $date->add(weeks => 1);
    }
    elsif ($char eq 'h') {
        $date->subtract(days => 1);
    }
    elsif ($char eq 'l') {
        $date->add(days => 1);
    }
    else {
        warn "Unknown key!\n";
    }
}
