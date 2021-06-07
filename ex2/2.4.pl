# Create an array containing all natural numbers from 1 to 5 and from 11 to 15. Remove the
# first element of the new array. Divide the last element of the array by 5. Print the contents of
# the final array to be sure it worked. The final array should contain:
# 2 3 4 5 11 12 13 14 3

my @array;

for (my $i = 1; $i <= 15; $i++) {
    if (6 <= $i && $i <= 10) { next; }
    push(@array, $i);
}

print "before: ", "@array","\n";

shift @array; # shift whole array to the left
$array[$#array] = $array[$#array] / 5;

print "final: ", "@array","\n";
