# Define 4 variables $x, $y, $a and $b and fill them with numbers. Now write a subroutine that
# calculates the difference of two variables that get passed on as parameters. Inside the
# subroutine use private variables called $a and $b to do the calculation (i.e. copy over the
# contents of @_). Use the subroutine to calculate the difference between $x and $y first and
# then the difference between $a and $b that you defined in the very beginning. Check what
# happens if don’t make sure that the $a and $b inside the subroutine are private.

my $x = 5, $y = 10, $a = 50, $b = 100;

sub difference {
    my $a = $_[0];
    my $b = $_[1];

    print "difference: ", abs($a - $b), "\n";
}

difference($x, $b);