# Create an array with all numbers between 1 and 20000. Sort the array (alphabetically) and
# print the result to the screen. Measure how long this whole procedure took (in seconds) and
# report it back to the user. Try it within the IDE and on the console.

my @aNumbers;
my $iLimit = 20000;

for (my $i = 0; $i <= $iLimit; $i++) {
    push(@aNumbers, $i);
}

my $sBefore = time();
@aSorted = sort @aNumbers;
my $sAfter = time();

print sort @aNumbers;
print "\n";
print "sorting took ",$sAfter - $sBefore," seconds\n";