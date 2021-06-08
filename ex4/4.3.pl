# In the last program also directories where listed. Modify the program so only files get printed.

my $sDir = "../";
my @files;
opendir(my $dir, $sDir) or die "cannot open directory: $!";
@files = grep {-T $sDir."$_"} readdir $dir; # filter out files only

foreach (@files) {
    my $now = time();
    my $lastModified = (stat($_))[9]; # get last modified stat
    my $howLongAgo = $now - $lastModified;
    # print $_, " was modified ", $howLongAgo," seconds ago\n";

    if ($howLongAgo >= (60*60*24)) { # convert seconds to hours
        print $_, ": file was last modified more than 24 hours ago.\n"
    }
}
