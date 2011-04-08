#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use File::Find 'find';

find({
    wanted => sub {
        my $filename = $_;
        return if $filename =~ m{/\.};
        open my $fh, $filename or die $!;
        my $lines = join '', (<$fh>);

        # 1: All Images have alt text
        for my $link ($lines =~ /(<img[^>]+>)/gs) {
            my ($src) = $link =~ /src=["']([^"']+)/;
            my ($alt) = $link =~ /alt=["']([^"']+)/;
            next if $src =~ m{background.jpg$};
            ok $alt, "Alt text for $filename:$src";
        }

        # <b> and <i> elements aren't read properly by screen readers
        ok $lines !~ m{</?b>}, "No <b>'s in $filename";
        ok $lines !~ m{</?i>}, "No <i>'s in $filename";
    },
    no_chdir => 1,
}, 'template', 'root/javascript/template');

done_testing;
