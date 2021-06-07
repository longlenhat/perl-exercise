use strict;
use warnings;

print "input a number: ";
my $num = <STDIN>;

print "Number is ", ($num % 2 == 0) ? "even" : "odd";
print "\n";

for (my $i = 1; $i <= scalar $num; $i++) {
    print $i, " ";
}
print "\n";
