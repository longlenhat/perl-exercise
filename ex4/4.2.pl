opendir(my $dir, "./") or die "cannot open directory: $!";
my @files = readdir $dir;
# print "current folder contents: ", "@files", "\n";
closedir $dir;

foreach (@files) {
    my $now = time();
    my $lastModified = (stat($_))[9];
    my $howLongAgo = $now - $lastModified;
    print $_, " was modified ", $howlongAgo," seconds ago\n";

    # if ($howLongAgo >= (60*60*24)) {
    #     print $_, ": file was last modified more than 24 hours ago.\n"
    # }
}