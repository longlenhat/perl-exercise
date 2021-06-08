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