use strict;
use warnings;

# "scalars"
my $myvar = 5;
my $bool = 1;

print $myvar;
print "\n";

# arrays
my @array = (
    "this",
    "is", 
    "not",
    "fun",
);

print @array;
print "\n";

print "array length: " . (scalar @array);
print "\n";
print "last array index: " . $#array;
print "\n";

print "Me: @array";
print "\n";

# hash variables
my %scientists = (
    "Newton" => "Isaac",
    "Einstein" => "Albert",
    "Darwin" => "Charles",
);
# convert hash -> array
my @scientists = %scientists;

print $scientists{"Einstein"};
print "\n";
print "@scientists";
print "\n";

# links and references
my $colour = "Indigo";
my $scalarRef = \$colour;
my @colours = ("Red", "Orange", "Yellow", "Green", "Blue");
my $arrayRef = \@colours;
my %atomicWeights = ("Hydrogen" => 1.008, "Helium" => 4.003, "Manganese" => 54.94);
my $hashRef = \%atomicWeights;

print $$scalarRef; # dereferencing scalar $ { $scalarRef }
print "\n";
print $arrayRef->[0]; # dereferencing array
print "\n";
print $hashRef->{"Manganese"}; # dereferencing hash
print "\n";
