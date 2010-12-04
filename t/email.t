#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use File::Copy qw/copy/;
use FindBin;
use IO::All;
use t::Recollect;

use_ok 'Recollect::Email';

my $email = Recollect::Email->new( base_path => "$FindBin::Bin/.." );
isa_ok $email, 'Recollect::Email';

$email->send_email(
    to => 'test@recollect.net',
    subject => "You've won one million dollars!",
    template => 'test',
    template_args => { foo => 'bar' },
);

my $contents = t::Recollect->email_content;
like $contents, qr/\QTo: test/, 'to';
like $contents, qr/\QFrom: Recollect <noreply/, 'from';
like $contents, qr/\QSubject: You've won\E/, 'subject';
like $contents, qr/foo is bar/, 'template works';

done_testing();
exit;

