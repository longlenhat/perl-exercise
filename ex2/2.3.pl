# Write a program that swaps the values of two variables without the simple swapping
# technique.

my $var1 = "test1";
my $var2 = "test2";
my $var3;
print "before: ", "$var1 $var2";
print "\n";

# simple swap
# ($var1, $var2) = ($var2, $var1);

# swap with 3rd var
$var3 = $var1;
$var1 = $var2;
$var2 = $var3;

print "after: ", "$var1 $var2";
print "\n";