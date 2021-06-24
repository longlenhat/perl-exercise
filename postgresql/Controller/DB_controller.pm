#!/usr/bin/env perl
package DB_controller;

use strict;
use warnings;
use DBI;
use Digest::MD5 qw(md5_hex);
use Scalar::Util qw(looks_like_number);

# database config params
my $s_dbname          = "";
my $s_hostname        = "127.0.0.1";
my $s_port            = "5432";
my $s_username        = "postgres";
my $s_password        = "postgres";
my $o_db_handler      = ();
my @a_os_types        = ("ubuntu", "debian", "opensuse");
my %h_lookup_os_types = map {$_ => undef} @a_os_types;

# constructor, connects to database that's been passed as standard user
sub new {
   my ($self, $hr_params) = @_;
   $s_dbname = $hr_params->{"db_name"};
   die "must provide database name 'db_name' to connect to!\n"
      if $s_dbname eq "";

   # connection config
   $o_db_handler = DBI->connect(
      "dbi:Pg:dbname=$s_dbname;host=$s_hostname;port=$s_port", # db name and host
      $s_username,                                             # uname
      $s_password,                                             #pw
   ) or die $DBI::errstr;

   return bless {"db_name" => $s_dbname}, $self;
}

# checks the os type against list of pre-defined values, dies if os is not in list
sub _check_os_type {
   my ($os) = @_;
   die "error caught: os type must be one of these: {",
      join(", ", @a_os_types), "}\n"
      if (!exists $h_lookup_os_types{$os});
}

# checks if a row in table storage can be deleted
sub _can_delete_storage {
   my ($hr_params) = @_;
   my $s_name      = $hr_params->{"name"};
   my $s_id        = $hr_params->{"id"};
   my $s_query     = "";
   my $o_results   = ();
   my @a_row       = ();

   # if only a name is passed we need to query the storage id
   if ($s_name) {
      $s_query   = "SELECT id FROM STORAGE WHERE name='$s_name';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();
      @a_row = $o_results->fetchrow_array();

      # if no results, storage name does not exists, return false
      if (scalar @a_row == 0) {
         return 0;
      }

      # else we get the id of storage and check if this id is being referenced in table vm
      $s_id = $a_row[0];

      $s_query   = "SELECT fk_storage FROM vm WHERE fk_storage=$s_id";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();
      @a_row = $o_results->fetchrow_array();

      # if no results, then the storage id is not present as a fk_storage and said storage can be deleted
      if (scalar @a_row == 0) {
         return 1;
      }

      # otherwise if there are results return false
      return 0;
   } elsif ($s_id) {    # if id is passed then we can use it
      $s_query   = "SELECT fk_storage FROM vm WHERE fk_storage=$s_id";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();
      @a_row = $o_results->fetchrow_array();

      # if no results, then the storage id is not present as a fk_storage and said storage can be deleted
      if (scalar @a_row == 0) {
         return 1;
      }

      # otherwise if there are results return false
      return 0;
   }
}

# returns db_handler if needed
sub get_db_handler {
   return $o_db_handler;
}

# sets new dbhandler if needed
sub set_db_handler {
   my ($self, $dbh) = @_;
   $o_db_handler = $dbh;
}

# query a table and return 2 arrays containing column names and the row values
sub get_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_query     = "";
   my $o_results   = ();
   my @a_results   = ();
   die "cannot get table: must provide 'table_name'!\n" if !$s_tablename;

   $s_query   = "SELECT * FROM $s_tablename;";
   $o_results = get_db_handler()->prepare($s_query);

   my $_results = $o_results->execute() or die $DBI::errstr;

   if ($_results < 0) {
      print $DBI::errstr;
   }

   my $s_line    = "";
   my $col_names = $o_results->{NAME};

   # # pretty print the table onto console
   # for ( my $i = 0 ; $i < scalar @$col_names ; $i++ ) {
   #     print " " . $col_names->[$i] . " |";
   #     $s_line =
   #         $s_line
   #       . "-" x ( length( $col_names->[$i] ) + 2 )
   #       . "+";    # pretty horizontal line
   # }

   # print "\n", $s_line, "\n";

   while (my @a_row = $o_results->fetchrow_array()) {
      push(@a_results, @a_row);

      # # pretty print the table onto console
      # for ( my $i = 0 ; $i < scalar @a_row ; $i++ ) {
      #     my $s_pad =
      #       " " x ( length( $col_names->[$i] ) - length( $a_row[$i] ) )
      #       ;    # calculating empty spaces for padding the table
      #     print " " . $a_row[$i] . $s_pad . " |";
      # }

      # print "\n";
   }

   return (\@$col_names, \@a_results);
}

# inserts given row with values into the table
sub add_row_to_table {
   my ($self, $s_tablename, $hr_params) = @_;

   my $s_name       = $hr_params->{"name"};
   my $s_checksum   = $hr_params->{"checksum"};
   my $s_created_on = $hr_params->{"created_on"};
   my $s_query      = "";

   die "cannot add row to table: must provide at least table_name and column values!\n"
      if (!$s_tablename || !$s_name);

   if ($s_tablename eq "vm") {
      my $s_os = $hr_params->{"os"};
      _check_os_type($s_os);
      $s_query = "INSERT INTO $s_tablename (name, operating_system, checksum, created_on, last_modified)
                  VALUES ('$s_name', '$s_os', '$s_checksum', '$s_created_on', '$s_created_on');";

   } elsif ($s_tablename eq "storage") {
      my $s_capacity = $hr_params->{"capacity"};
      die "cannot add row to table: capacity must be a numeric value (in megabytes)!\n" if !looks_like_number($s_capacity);
      $s_capacity = $s_capacity . "mb";
      $s_query =
         "INSERT INTO $s_tablename (name, capacity, created_on, last_modified)
                  VALUES ('$s_name', '$s_capacity', '$s_created_on', '$s_created_on');";
   }

   get_db_handler()->prepare($s_query)->execute() or die $DBI::errstr;

   print "row successfully added to table '$s_tablename'\n";
}

# delete specific row from a table
sub delete_row_from_table {
   my ($self, $s_tablename, $hr_params) = @_;

   my $s_name  = $hr_params->{"name"};
   my $s_id    = $hr_params->{"id"};
   my $s_query = "";

   # checks for tablename to not be empty
   die "cannot delete row from table: must provide table_name!\n"
      if (!$s_tablename);

   # checks if storage can be deleted
   if ($s_tablename eq "storage") {
      die "cannot delete row from storage: storage does not exist or is being referenced in table 'vm'\n"
         if (!_can_delete_storage($hr_params));
   }

   if ($s_name) {
      $s_query = "DELETE FROM $s_tablename WHERE name='$s_name';";
   }
   elsif ($s_id) {
      $s_query = "DELETE FROM $s_tablename WHERE id='$s_id';";
   }
   else {
      die "cannot delete row from table: must provide condition for row to be deleted!\n";
   }

   get_db_handler()->prepare($s_query)->execute() or die $DBI::errstr;

   print "row successfully removed from table '$s_tablename'\n";
}

# query all rows from a table given a condition
sub get_rows_from_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_condition = $hr_params->{"condition"};
   my $s_query     = "";
   my $o_results   = ();

   die "cannot fetch rows: must provide 'table_name' and 'condition'!\n"
      if (!$s_tablename || !$s_condition);

   $s_query   = "SELECT * FROM $s_tablename WHERE $s_condition;";
   $o_results = get_db_handler()->prepare($s_query);
   my $_results = $o_results->execute() or die $DBI::errstr;

   if ($_results < 0) {
      print $DBI::errstr;
   }

}

# select a single column from a table
sub get_col_from_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_col       = $hr_params->{"column"};
   my $s_query     = "";
   my $o_results   = ();

   die "cannot fetch column: must provide 'table_name' and 'column'!\n"
      if (!$s_tablename || !$s_col);

   $s_query   = "SELECT $s_col FROM $s_tablename;";
   $o_results = get_db_handler()->prepare($s_query);
   my $_results = $o_results->execute() or die $DBI::errstr;

   if ($_results < 0) {
      print $DBI::errstr;
   }

   my @a_col_entries = ();

   # print "printing entries from column $s_col: \n";
   while (my @a_row = $o_results->fetchrow_array()) {

      # print "@a_row\n";
      push(@a_col_entries, @a_row);
   }

   return @a_col_entries;
}

# updates a specific row in table
sub update_row_in_table {
   my ($self, $hr_params) = @_;
   my $s_tablename     = $hr_params->{"table_name"};
   my $s_col           = $hr_params->{"col"};
   my $s_new_value     = $hr_params->{"new_value"};
   my $s_condition     = $hr_params->{"condition"};
   my $s_query         = "";
   my $s_last_modified = localtime;                   # set last_modified to now

   die "cannot update row: must provide 'table_name', 'col', 'new_value' and 'condition'!\n"
      if (!$s_tablename || !$s_col || !$s_new_value || !$s_condition);

   my $s_new_checksum = md5_hex($s_new_value, $s_last_modified); # new checksum uses new updated value and last_modified date

   if ($s_col eq "os" || $s_col eq "operating_system") {    # checks os type
      _check_os_type($s_new_value);
   }

   if ($s_col eq "capacity" && !looks_like_number($s_new_value)) {
      die "cannot update row: capacity must be a numeric value (in megabytes)!\n";
   }

   if ($s_tablename eq "vm") {
      $s_query = "UPDATE $s_tablename 
                  SET $s_col = '$s_new_value',
                     checksum='$s_new_checksum',
                     last_modified='$s_last_modified'
                  WHERE $s_condition;";
   }
   else {
      $s_new_value = $s_new_value . "mb";
      $s_query     = "UPDATE $s_tablename
                  SET $s_col = '$s_new_value',
                     last_modified='$s_last_modified'
                  WHERE $s_condition;";
   }

   get_db_handler()->prepare($s_query)->execute() or die $DBI::errstr;

   print "updated colum '$s_col' with new value '$s_new_value' in table '$s_tablename'\n";
}

# link a storage object from the storage table to an object in the vm table
sub add_storage_to_vm {
   my ($self, $hr_params_storage, $hr_params_vm) = @_;
   my $s_storage_name  = $hr_params_storage->{"name"};
   my $s_storage_id    = $hr_params_storage->{"id"};
   my $s_vm_name       = $hr_params_vm->{"name"};
   my $s_vm_id         = $hr_params_vm->{"id"};
   my $s_query         = "";
   my $o_results       = ();
   my @a_row           = ();
   my $s_last_modified = localtime;                   # set last_modified to now
   my $s_new_checksum  = "";

   die "cannot add storage to vm: must at least provide storage name!\n"
      if ($s_vm_name eq "");

   # get id of storage first if not provided
   if (!$s_storage_id) {
      $s_query   = "SELECT id FROM STORAGE WHERE name='$s_storage_name';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();
      @a_row = $o_results->fetchrow_array();
      if (scalar @a_row == 0) {
         $s_storage_id = 'null';
      }  # if no results, storage name does not exists, set storage_name to null
      $s_storage_id = $a_row[0];
   }

   $s_new_checksum = md5_hex($s_storage_id, $s_last_modified); # new checksum uses storage id and last_modified date

   # setting the storage id as fk_storage in table vm
   if ($s_vm_name) {
      $s_query = "UPDATE vm 
                  SET fk_storage=$s_storage_id,
                     last_modified='$s_last_modified',
                     checksum='$s_new_checksum'
                  WHERE name='$s_vm_name';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();

      print "added storage_id $s_storage_id as foreign key to vm '$s_vm_name'\n";
   } elsif ($s_vm_id) {
      $s_query = "UPDATE vm 
                  SET fk_storage=$s_storage_id,
                     last_modified='$s_last_modified',
                     checksum='$s_new_checksum'
                  WHERE id='$s_vm_id';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();

      print "added storage_id $s_storage_id as foreign key to vm with id=$s_vm_id\n";
   }

}

sub remove_storage_from_vm {
   my ($self, $hr_params) = @_;
   my $s_name          = $hr_params->{"name"};
   my $s_id            = $hr_params->{"id"};
   my $s_query         = "";
   my $o_results       = ();
   my $s_last_modified = localtime;              # set last_modified to now
   my $s_new_checksum =
      md5_hex($s_last_modified);    # new checksum uses last_modified date

   # set fk_storage to null
   if ($s_name) {
      $s_query = "UPDATE vm 
                  SET fk_storage=null,
                     last_modified='$s_last_modified',
                     checksum='$s_new_checksum'
                  WHERE name='$s_name';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();

      print "removed storage from vm '$s_name'\n";
   } elsif ($s_id) {
      $s_query = "UPDATE vm 
                  SET fk_storage=null,
                     last_modified='$s_last_modified',
                     checksum='$s_new_checksum'
                  WHERE id='$s_id';";
      $o_results = get_db_handler()->prepare($s_query);
      $o_results->execute();

      print "removed storage from vm with id=$s_id\n";
   }
}

return 1;
