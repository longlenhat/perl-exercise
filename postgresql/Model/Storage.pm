package Storage;
use strict;
# use warnings;
use Time::Piece;
use Digest::MD5 qw(md5_hex);

sub new {
   my ($class, %args) = @_;
   my $self = {
      "name" => $args{"name"} || "undefined",
      "capacity" => $args{"capacity"} || "undefined",
   };

   my $o_stor = bless ($self, $class);
   $o_stor->_set_datetime();
   $o_stor->_calculate_checksum();
   return $o_stor;
}

sub _set_datetime {
   my $self = shift @_;
   my $s_time = localtime;
   $self->{"created_on"} = $s_time;
}

sub _calculate_checksum {
   my $self = shift @_;
   my $s_checksum = md5_hex( # create init checksum
      $self->{"id"},
      $self->{"name"},
      $self->{"capacity"},
      $self->{"created_on"},
      $self->{"last_modified"},
   );
   $self->{"checksum"} = $s_checksum;
}
return 1;