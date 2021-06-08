# Fill two arrays with several words. Some elements within the two arrays should be the same, some different. 
# Write a program that compares the contents of both arrays and reports the elements they have in common. 
# Try using the smart-match operator.

my @aGreek = ("Alpha","Beta","Gamma","Delta","Epsilon","Psi","Eta","My","Ny","Xi");
my @aPhonetic = ("Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel","India","Juliett");

sub compare {
    my (@aArr1, @aArr2) = @_;

    my @aIsect, @aDiff, %mCount;

    # loops through both arrays, map all array elements as keys and
    # increment their value by 1 for each occurence
    foreach $item (@aArr1, @aArr2) { $mCount{$item}++;}
    foreach $item (keys %mCount) {
        if ($mCount{$item} == 2) { # check the values for each key, if it is 2 then that element was present in both arrays
            push @aIsect, $item; # add that particular element into separate array "intersect"
        } else {
            push @aDiff, $item; # add all unique elements into separate array "diff"
        }
    }

    print "common elements: (", join(", ", sort @aIsect), ")\n";
} 

compare(@aGreek, @aPhonetic);