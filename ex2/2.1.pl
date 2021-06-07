# Create an array of 3 elements, where the elements contain the letters “a”, “b” and “c”
# respectively. Write a program that prints each element on a new line. Use a while loop to
# achieve this.
my @array = ("a", "b", "c");

my $i = 0;
while ($i < scalar @array) {
    print $array[$i];
    print "\n";
    $i++;
}