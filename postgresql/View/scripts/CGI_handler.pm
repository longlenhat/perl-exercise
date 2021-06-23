#!/usr/bin/env perl
use strict;
use warnings;
use CGI;
my $cgi = CGI->new();
print $cgi->header( -type => 'text/plain' );

print <<'END';
This is now text
END
