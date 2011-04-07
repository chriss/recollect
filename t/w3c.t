#!/usr/bin/perl
use strict;
use warnings;
use Test::More;

use File::Find 'find';

All_Images_have_alt_text: {
    find({
        wanted => sub {
            my $filename = $_;
            return if $filename =~ m{/\.};
            open my $fh, $filename or die $!;
            my $lines = join '', (<$fh>);
            for my $link ($lines =~ /(<img[^>]+>)/gs) {
                my ($src) = $link =~ /src=["']([^"']+)/;
                my ($alt) = $link =~ /alt=["']([^"']+)/;
                ok $alt, "$filename: $src";
            }
        },
        no_chdir => 1,
    }, 'template', 'root/javascript/template');
}

done_testing;
