my @os_types = ("ubuntu","debian","opensuse");
my $os = "ubuntu";

my %lookup = map { $_ => undef } @os_types;

if (!exists $lookup{$os}) {
   print "not exists";
}
