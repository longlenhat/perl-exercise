# Rewrite our array printing loop (2.2.pl) using foreach instead of while.

use strict;
use warnings;

print "input a sentence: ";
my $sentence = <STDIN>;
my @sentence = split(" ", $sentence); 

foreach (@sentence) {
    print "$_\n";
} 