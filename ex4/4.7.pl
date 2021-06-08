$stoBeDeletedDir = "./temp/BAK/";

# remove directory if empty, else delete all files first
if (!rmdir $stoBeDeletedDir) {
    my @files = glob "$stoBeDeletedDir/*";
    foreach (@files) { # delete all files in folder
        unlink $_;
        print $_, " deleted\n";
    }
    rmdir $stoBeDeletedDir or die "cannot delete directory: $!\n";
    print $stoBeDeletedDir, " deleted\n";
}