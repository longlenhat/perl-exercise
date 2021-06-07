# Create an array containing all natural numbers from 1 to 5 and from 11 to 15. Now multiply
# each element of the array by 2. Print the contents of the final array to be sure it worked. The
# final array should contain:
# 2 4 6 8 10 22 24 26 28 30

my @array;

for (my $i = 1; $i <= 15; $i++) {
    if (6 <= $i && $i <= 10) { next; }
    push(@array, $i * 2);
}

print "@array\n";