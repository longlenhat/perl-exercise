use File::Basename;
use File::Copy;

my $sTempDir = "./temp/";
my $sSourceFileName = $sTempDir . "genes.txt";
my $sDestFileName = $sTempDir . "genes_copy.txt";

sub createFiles {
    unless (open FILE, ">".$sSourceFileName) { 
        die "unable to create file: $!"; 
    }
    print "file $sSourceFileName created\n";

    copy($sSourceFileName, $sDestFileName) or die "Copy failed: $!";
    print "File ", basename($sSourceFileName), " copied to ", basename($sDestFileName),"\n";
}

sub deleteFiles {
    unlink($sSourceFileName);
    print "$sSourceFileName deleted\n";
    unlink($sDestFileName);
    print "$sDestFileName deleted\n";
}

createFiles();
# deleteFiles();