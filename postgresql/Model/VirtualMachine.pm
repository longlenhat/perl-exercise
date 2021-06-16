package VirtualMachine;
use strict;
use warnings;

sub new {
    my ($class, %args) = @_;
    my $self = {
        "name" => $args{"name"} || "undefined",
        "os" => $args{"os"} || "undefined",
        "checksum" => $args{"checksum"} || "undefined",
    };
    
    my $o_vm = bless ($self, $class);
    $o_vm->_set_datetime();
    return $o_vm;
}

sub _set_datetime {
    my $self = shift @_;
    my $s_time = localtime;
    $self->{"created_on"} = $s_time;
}

return 1;