# Fill an array with a couple of words of different lengths and create a new array containing
# only those words that contain 4 or more letters. Try using grep!

my @aWords = ("Alpha","Beta","Gamma","Delta","Epsilon","Psi","Eta","My","Ny","Xi");
my @aFiltered = grep {length $_ >= 4} @aWords;
print "Elements with more than 4 characters: @aFiltered\n";