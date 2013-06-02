#!/usr/bin/perl

use warnings;

use Test::More tests => 4;

use lib "/Users/scholnick/perl/t2t";

use T2t::Utilities;

my $returnCode = is( "string", trim("  string  "), "trim" );
exit 1 if ! $returnCode;

$returnCode = is( "/Users/scholnick/.t2trc", getResourceFilePath(".t2trc", "t2t.rc"), "getResourceFilePath" );
exit 1 if ! $returnCode;

$returnCode = is( "/Users/scholnick/file", expandPath("~/file"), "Expand path with ~" );
exit 1 if ! $returnCode;

$returnCode = is( "/Users/scholnick/file", expandPath("/Users/scholnick/file"), "Expand path without ~" );
exit 1 if ! $returnCode;

exit 0;


