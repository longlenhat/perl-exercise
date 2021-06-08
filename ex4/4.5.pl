# Copy some text files (with the extension .txt) into a temporary folder on drive D called
# “TEMP”. Write a program that renames all of those files into files with .bak extensions.
# HINT: Use regular expressions to replace any trailing .txt with .bak for each found file.
use File::Basename;

my $sTempDir = "./temp/";

# create temp folder if not already created
unless (mkdir($sTempDir)) {
    print "Unable to create directory: $!\n";
}

# create sample test.txt files
for (my $i = 1; $i <= 3; $i++) {
    my $sFileName = $sTempDir."test".$i.".txt";
    unless (open FILE, ">".$sFileName) { 
        die "unable to create file: $!"; 
    }
}

# sub for converting .txt files to .bak files
sub txtToBak {
    my @files = glob "$sTempDir/*.txt";
    foreach (@files) {
        my $sOldName = $_;
        (my $sNewName = $sOldName) =~ s/\.[^.]+$//; # regex for filtering out the filename without extension
        $sNewName =  $sNewName . ".bak";
        rename $_, $sNewName or die "cannot rename file: $!";
        print basename($_), " renamed to ", basename($sNewName), "\n";
    }
}

# sub for converting .bak files to .txt files
sub bakToTxt {
    my @files = glob "$sTempDir/*.bak";
    foreach (@files) {
        my $sOldName = $_;
        (my $sNewName = $sOldName) =~ s/\.[^.]+$//; # regex for filtering out the filename without extension
        $sNewName =  $sNewName . ".txt";
        rename $_, $sNewName or die "cannot rename file: $!";
        print basename($_), " renamed to ", basename($sNewName), "\n";
    }
}

txtToBak();