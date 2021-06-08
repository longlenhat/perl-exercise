# Create a program that returns only the “head” of an array, meaning only a certain number of elements 
# at the very front of the array. Let the user specify how many elements from the start of the array should be returned. 
# If the specified number of elements is bigger than the whole original array, just return the complete original array. 
# Print the new array to screen to see if it worked!

my @aWords = ("Alpha","Beta","Gamma","Delta","Epsilon","Psi","Eta","My","Ny","Xi");

sub head {
    my ($iNum, @aArr) = @_;
    # print $iNum,"\n";
    # print "@aArr","\n";
    if ($iNum > scalar @aArr) {
        print join(", ", @aArr),"\n";
    } else {
        print "filtered the first $iNum elements: ", join(", ", splice(@aArr, 0, $iNum)),"\n";
    }
}

head(6,@aWords);