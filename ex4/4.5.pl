my $sTempDir = "./temp/";
opendir(my $dir, $sTempDir) or die "cannot open directory: $!";
# my @files = grep {/\.txt$/} readdir $dir;
# my @files = grep {-T "./temp/$_"} readdir $dir;
my @files = glob "$sTempDir/*.txt";

foreach (@files) {
    print $_, "\n";
    my $sOldName = $_;
    (my $sNewName = $sOldName) =~ s/\.[^.]+$//;
    $sNewName =  $sNewName . ".bak";
    print $sNewName, "\n";
    rename $_, $sNewName or die "cannot rename file: $!";
}