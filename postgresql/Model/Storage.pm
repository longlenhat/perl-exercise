package Storage;
use strict;
use warnings;
use Time::Piece;

sub new {
    my ($class, %args) = @_;
    my $self = {
        "name" => $args{"name"} || "undefined",
        "capacity" => $args{"capacity"} || "undefined",
    };

    my $o_stor = bless ($self, $class);
    $o_stor->_set_datetime();
    return $o_stor;
}

sub _set_datetime {
    my $self = shift @_;
    my $s_time = localtime;
    $self->{"date_created"} = $s_time;
}

return 1;