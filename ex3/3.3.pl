sub arrSum {
    @array = $_[0];

    print "@array\n";
}

my @array = (1,2,3);
arrSum(@array);