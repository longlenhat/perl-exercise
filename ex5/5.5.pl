# Take the original array from your last exercise and upper-case all elements. 
# Try using map!

my @aWords = ("Alpha","Beta","Gamma","Delta","Epsilon","Psi","Eta","My","Ny","Xi");
print join(", ", map {uc $_ } @aWords), "\n";