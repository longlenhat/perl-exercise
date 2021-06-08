# Update the guessing game from 9.5.pl to randomly generate a number 
# between 1 and 100 to guess for you. (So playing the game is much more fun!)

use strict;
use warnings;

my $iRandNum = int(rand(100));

print "Guess my number between 1 and 100: ";
my $iGuess = <STDIN>;

while ($iGuess != $iRandNum) {
    if ($iGuess < 0 || $iGuess > 100) {
        print "number has to be between 0 and 100!\n";
        $iGuess = <STDIN>;
    } elsif ($iGuess > $iRandNum) {
        print "a little bit lower!\n";
        $iGuess = <STDIN>;
    } elsif ($iGuess < $iRandNum) {
        print "a little bit higher!\n";
        $iGuess = <STDIN>;
    }
}

print "Thats correct! My number was $iRandNum.\n";
