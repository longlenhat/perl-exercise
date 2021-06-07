use strict;
use warnings;

print "input a number: ";
my $num = <STDIN>;

for (my $i = 1; $i <= scalar $num; $i++) {
    print $i, " ";
}
print "\n";
