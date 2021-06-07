# Define a variable called $x and put a number into it. Now write a subroutine called
# “increment” that adds 1 to this variable. Use this subroutine to increment the contents of $x
# three times. Print $x to see if it worked.

$x = 4;

sub increment {
    $x++;
}

print "before: ", $x, "\n";
increment();
increment();
increment();
print "after: ", $x, "\n";
