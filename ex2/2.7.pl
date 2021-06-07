# Define an array with the strings “Fred”, “Wilma”, “Pebbles”. Replace the middle element
# with two new elements containing “Barney” and “Betty”, store the middle element into the
# variable $room. Now insert an element containing “Bamm-Bamm” to be at the second
# position of the array. Print $room and the final array to see if it worked.

my @array = ("Fred","Wilma","Pebbles");
my @newElements = ("Barney","Betty");
my $middle = int(scalar @array / 2);
my $room = @array[$middle];

splice(@array, $middle, 1, @newElements); # splice @array to remove middle element and insert @newElements into it

print $room,"\n";
print "@array\n";

splice(@array, 1, 0, "Bamm-Bamm"); # insert element at index 1
print "@array\n";