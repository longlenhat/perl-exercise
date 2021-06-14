use strict;
use warnings;
use Time::Piece;

package Storage;

sub new {
    my ($class, %args) = @_;
    my $self = {
        "name" => $args{"name"} || "undefined",
        "capacity" => $args{"capacity"} || "undefined",
    };
    my $o_vm = bless ($self, $class);
    $o_vm->_set_datetime();
    return $o_vm;
}

sub _set_datetime {
    my $self = shift @_;
    my $s_time = localtime;
    $self->{"datetime"} = $s_time;
}

return 1;