use File::Basename;
use File::Copy;

my $sTempDir = "./temp/";
my $sSourceFileName = $sTempDir . "genes.txt";
my $sDestFileName = $sTempDir . "genes_copy.txt";

sub createFiles {
    unless (open FILE, ">".$sSourceFileName) { # create genes.txt file
        die "unable to create file: $!"; 
    }
    print "file $sSourceFileName created\n";

    copy($sSourceFileName, $sDestFileName) or die "Copy failed: $!"; # copy file to genes_copy.txt
    print "File ", basename($sSourceFileName), " copied to ", basename($sDestFileName),"\n";
}

# deletes the files
sub deleteFiles {
    unlink($sSourceFileName);
    print "$sSourceFileName deleted\n";
    unlink($sDestFileName);
    print "$sDestFileName deleted\n";
}

createFiles();
# deleteFiles();