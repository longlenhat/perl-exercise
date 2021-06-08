# Create a new directory within TEMP called “BAK” and move the renamed .bak files from the
# last exercise into this directory. HINT: Move them one by one using a foreach loop.
use File::Basename;
use File::Copy;

my $sTempDir = "./temp/";
my $sNewDir = $sTempDir . "BAK/";
unless (mkdir($sNewDir)) {
    print "Unable to create directory: $!\n";
}


sub moveToFolder {
    my @files = glob "$sTempDir/*.bak";
    foreach (@files) {
        move($_, $sNewDir . basename($_));
        print basename($_), " moved to $sNewDir\n";
    }
}

sub moveOutFolder {
    my @files = glob "$sNewDir/*.bak";
    foreach (@files) {
        move($_, $sTempDir . basename($_));
        print basename($_), " moved to $sTempDir\n";
    }
}

moveToFolder();