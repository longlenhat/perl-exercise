# Call the Windows command “dir c:\\windows” from within a Perl script. Capture the output of “dir” and 
# print to the screen only those lines that display info about a directory (the lines containing <DIR>).

my $sSystemCall = `ls`;
print $sSystemCall; 