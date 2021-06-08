$stoBeDeletedDir = "./temp/BAK/";

if (!rmdir $stoBeDeletedDir) {
    my @files = glob "$stoBeDeletedDir/*";
    foreach (@files) {
        unlink $_;
        print $_, " deleted\n";
    }
    rmdir $stoBeDeletedDir or die "cannot delete directory: $!\n";
    print $stoBeDeletedDir, " deleted\n";
}