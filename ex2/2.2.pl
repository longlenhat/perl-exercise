# Put the words of the sentence “I am learning Perl” into an array, where each element contains
# a single word. Print the sentence one word below the other. Check if the program still works if
# you enter sentences of different lengths. HINT: Use the $#array special variable!
use strict;
use warnings;

print "input a sentence: ";
my $sentence = <STDIN>;
my @sentence = split(" ", $sentence); 

print ("$_\n") for @sentence;