use Data::Dumper;

# a couple of arrays of data to put in a loop:
my @words     = qw(I Am Cool);
my @numbers   = qw(1 2 3);
my @loop_data = ();              # initialize an array to hold your loop

while ( @words and @numbers ) {
    my %row_data;                # get a fresh hash for the row data

    # fill in this row
    $row_data{WORD}   = shift @words;
    $row_data{NUMBER} = shift @numbers;

    # the crucial step - push a reference to this row into the loop!
    push( @loop_data, \%row_data );
}

print Dumper(@loop_data);
