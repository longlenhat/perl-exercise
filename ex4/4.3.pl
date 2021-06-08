my @files;
opendir(my $dir, "./") or die "cannot open directory: $!";
@files = grep {-T "./$_"} readdir $dir;

foreach (@files) {
    # print $_, "\n";
    my $now = time();
    my $lastModified = (stat($_))[9];
    my $howLongAgo = $now - $lastModified;
    print $_, " was modified ", $howlongAgo," seconds ago\n";
}