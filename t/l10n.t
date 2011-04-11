#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use Recollect::l10n qw/loc loc_lang/;

is loc("Recollect"), 'Recollect', 'name';
is loc('Welcome to Recollect'), 'Welcome to Recollect', 'slogan';

loc_lang('fr');

is loc("Recollect"), 'Recollect', 'fr name';
is loc("Welcome to Recollect"), 'Bienvenue à se Recollect', 'fr slogan';
done_testing();
