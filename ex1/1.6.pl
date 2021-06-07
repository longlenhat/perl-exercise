use strict;
use warnings;

print "input first string: ";
my $string1 = <STDIN>;

print "input second string: ";
my $string2 = <STDIN>;

print "both strings are ", $string1 eq $string2 ? "equal" : "not equal";
print "\n";