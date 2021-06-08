# Copy some text files (with the extension .txt) into a temporary folder on drive D called
# “TEMP”. Write a program that renames all of those files into files with .bak extensions.
# HINT: Use regular expressions to replace any trailing .txt with .bak for each found file.
use File::Basename;

my $sTempDir = "./temp/";
# my @files = grep {/\.txt$/} readdir $dir;
# my @files = grep {-T "./temp/$_"} readdir $dir;
unless (mkdir($sTempDir)) {
    print "Unable to create directory: $!\n";
}

for (my $i = 1; $i <= 3; $i++) {
    my $sFileName = $sTempDir."test".$i.".txt";
    unless (open FILE, ">".$sFileName) { 
        die "unable to create file: $!"; 
    }
}

sub txtToBak {
    my @files = glob "$sTempDir/*.txt";
    foreach (@files) {
        my $sOldName = $_;
        (my $sNewName = $sOldName) =~ s/\.[^.]+$//;
        $sNewName =  $sNewName . ".bak";
        rename $_, $sNewName or die "cannot rename file: $!";
        print basename($_), " renamed to ", basename($sNewName), "\n";
    }
}

sub bakToTxt {
    my @files = glob "$sTempDir/*.bak";
    foreach (@files) {
        my $sOldName = $_;
        (my $sNewName = $sOldName) =~ s/\.[^.]+$//;
        $sNewName =  $sNewName . ".txt";
        rename $_, $sNewName or die "cannot rename file: $!";
        print basename($_), " renamed to ", basename($sNewName), "\n";
    }
}

txtToBak();