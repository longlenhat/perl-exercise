# Modify 3.2.pl so you can use the subroutine on any variable by passing it as a parameter when
# calling the subroutine. Apply the subroutine to two different variables (e.g. $x and $y). Print
# the results of the subroutine to see if it worked.

sub absolute {
    print abs($_[0]), " ", abs($_[1]),"\n";
}

absolute(-123,-53);