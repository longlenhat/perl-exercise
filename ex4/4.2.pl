# Write a program that gets the contents of a directory and then prints it to the screen, but only
# for files which haven’t been modified for at least 1 day. Try the directory where your Perl
# scripts are located.

opendir(my $dir, "../") or die "cannot open directory: $!";
my @files = readdir $dir;
closedir $dir;

foreach (@files) {
    my $now = time();
    my $lastModified = (stat($_))[9]; # get last modified stat
    my $howLongAgo = $now - $lastModified;
    # print $_, " was modified ", $howLongAgo," seconds ago\n";

    if ($howLongAgo >= (60*60*24)) { # convert seconds to hours
        print $_, ": file was last modified more than 24 hours ago.\n"
    }
}
