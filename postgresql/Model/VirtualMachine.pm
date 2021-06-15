package VirtualMachine;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {
        "name" => $args{"name"} || "undefined",
        "os" => $args{"os"} || "undefined",
        "storage" => $args{"storage"} || "undefined",
        "checksum" => $args{"checksum"},
    }
}

return 1;