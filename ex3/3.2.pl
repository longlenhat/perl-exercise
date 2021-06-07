# Write a subroutine called “absolute” that calculates the absolute value of number and returns
# it, i.e. if it finds a negative number it should return its positive counterpart. If the number is
# positive it should simply return the number. Print the returned value to check if it worked.

sub absolute {
    print abs($_[0]),"\n";
    return abs($_[0]);
}

absolute(-123);