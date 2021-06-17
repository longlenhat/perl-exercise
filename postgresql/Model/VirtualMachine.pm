package VirtualMachine;
use strict;
# use warnings;
use Digest::MD5 qw(md5_hex);

sub new {
   my ($class, %args) = @_;
   my $self = {
      "name" => $args{"name"} || "undefined",
      "os" => $args{"os"} || "undefined",
   };
   
   my $o_vm = bless ($self, $class);
   $o_vm->_set_datetime();
   $o_vm->_calculate_checksum();
   return $o_vm;
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
      $self->{"os"},
      $self->{"created_on"},
      $self->{"last_modified"},
      $self->{"fk_storage"},
   );
   $self->{"checksum"} = $s_checksum;
}

return 1;