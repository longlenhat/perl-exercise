# Write a subroutine that calculates the sum of an array (that you can define as you like) and
# returns it. Print the result to the screen.

sub arrSum {
    @array = @{$_[0]};
    $sum;

    foreach (@array) {
        $sum += $_;
    }

    print "@array\n";
    print "sum of array: ", $sum, "\n";
}

my @array = (1,2,3,4,5);
arrSum(\@array);