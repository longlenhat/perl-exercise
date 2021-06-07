# Modify 3.3.pl to immediately return the text “negative number found” if it finds a negative
# number in the array. If not it should still return the sum of the array.

sub arrSum {
    @array = @{$_[0]};
    $sum;
    
    foreach (@array) {
        if ($_ < 0) {
            return "negative number found\n";
        }
        $sum += $_;
    }

    return "sum of array: ", $sum, "\n";
}

my @array = (1,2,-3,4,5);
print arrSum(\@array);