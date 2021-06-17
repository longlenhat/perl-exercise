#!/usr/bin/env perl
package DB_controller;

use strict;
# use warnings;
use DBI;

my $s_dbname = "";
my $s_hostname = "127.0.0.1";
my $s_port = "5432";
my $s_username = "postgres";
my $s_password = "postgres";
my $o_db_handler = ();

# constructor
sub new {
   my ($self, $hr_params) = @_;
   $s_dbname = $hr_params->{"db_name"};
   die "must provide database name 'db_name' to connect to!\n" if $s_dbname eq "";

   # connection config
   $o_db_handler = DBI->connect(
      "dbi:Pg:dbname=$s_dbname;host=$s_hostname;port=$s_port", # db name and host
      $s_username, # uname
      $s_password, #pw
      # {AutoCommit => 0, RaiseError => 1, PrintError => 0},
   ) or die $DBI::errstr;
   print "successfully connected to database '$s_dbname'\n";
   return bless {"db_name" => $s_dbname}, $self;
}

# returns db_handler if needed
sub get_db_handler {
   return $o_db_handler;
}

sub set_db_handler {
   my ($self, $dbh) = @_;
   $o_db_handler = $dbh;
}

sub create_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   die "cannot create table: 'table_name' must be provided!\n" if $s_tablename eq "";

   my $query = "CREATE TABLE IF NOT EXISTS $s_tablename ();";
   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully created table '$s_tablename'\n";
}

sub delete_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   die "cannot delete table: 'table_name' must be provided!\n" if $s_tablename eq "";

   my $query = "DROP TABLE IF EXISTS $s_tablename;";
   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully deleted table '$s_tablename'\n";
}

sub add_column_to_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_col_name = $hr_params->{"col_name"};
   my $s_dataType = $hr_params->{"data_type"};
   my $s_constraint = $hr_params->{"constraint"};

   die "cannot add column: must provide table_name, col_name and data_type!\n" 
      if ($s_tablename eq "" || $s_col_name eq "" || $s_dataType eq "");
   
   my $query = "ALTER TABLE $s_tablename
               ADD COLUMN $s_col_name $s_dataType $s_constraint;";
   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully added column '$s_col_name' to table '$s_tablename'\n";

}

sub delete_column_from_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_col_name = $hr_params->{"col_name"};

   die "cannot delete column: must provide col_name!\n" if $s_col_name eq "";
   
   my $query = "ALTER TABLE $s_tablename DROP COLUMN $s_col_name;";
   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully deleted column '$s_col_name' from table '$s_tablename'\n";

}

sub get_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   die "cannot get table: must provide 'table_name'!\n" if $s_tablename eq "";

   my $query = "SELECT * FROM $s_tablename;";
   my $results = get_db_handler()->prepare($query);
   my $_results = $results->execute() or die $DBI::errstr;
   if ($_results < 0) {
      print $DBI::errstr;
   }
   my $s_line = "";
   my $col_names = $results->{NAME};
   for (my $i = 0; $i < scalar @$col_names; $i++) {
      print " " . $col_names->[$i] . " |";
      $s_line = $s_line . "-" x (length($col_names->[$i]) + 2) . "+"; # pretty horizontal line
   }

   print  "\n", $s_line,"\n";

   while (my @row = $results->fetchrow_array()) {
      for (my $i = 0; $i < scalar @row; $i++) {
         my $s_pad = " " x (length($col_names->[$i]) - length($row[$i])); # calculating empty spaces for padding the table
         print " " .  $row[$i] . $s_pad . " |";
      }
      print "\n";
   }
}

sub add_row_to_table {
   # insert into ... values ...
   my ($self, $s_tablename, $hr_params) = @_;
   # my $s_tablename = $hr_params->{"table_name"};
   my $s_name = $hr_params->{"name"};
   my $s_checksum = $hr_params->{"checksum"};
   my $s_created_on = $hr_params->{"created_on"};
   my $query = "";

   die "cannot add row to table: must provide at least table_name and column values!\n" 
      if ($s_tablename eq "" || $s_name eq "");

   if ($s_tablename eq "vm") {
      my $s_os = $hr_params->{"os"};
      $query = "INSERT INTO $s_tablename (name, operating_system, checksum, created_on, last_modified)
                  VALUES ('$s_name', '$s_os', '$s_checksum', '$s_created_on', '$s_created_on');";

   } elsif ($s_tablename eq "storage") {
      my $s_capacity = $hr_params->{"capacity"};
      $query = "INSERT INTO $s_tablename (name, capacity, created_on, last_modified)
                  VALUES ('$s_name', '$s_capacity', '$s_created_on', '$s_created_on');";
   }

   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "row successfully added to table '$s_tablename'\n";
}

sub delete_row_from_table {
   # delete from ... where ... (name/id/...)
   my ($self, $s_tablename, $hr_params) = @_;
   # my $s_tablename = $hr_params->{"table_name"};
   my $s_name = $hr_params->{"name"};
   my $s_id = $hr_params->{"id"};
   my $query = "";

   die "cannot delete row from table: must provide table_name!\n"
      if ($s_tablename eq "");

   if ($s_name ne "") {
      $query = "DELETE FROM $s_tablename WHERE name='$s_name';" 
   } elsif ($s_id ne "") {
      $query = "DELETE FROM $s_tablename WHERE id='$s_id';" 
   } else {
      die "cannot delete row from table: must provide condition for row to be deleted!\n";
   }

   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "row successfully removed from table '$s_tablename'\n";
}

sub get_rows_from_table {
   # ...
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_condition = $hr_params->{"condition"};

   die "cannot fetch rows: must provide 'table_name' and 'condition'!\n" 
      if ($s_tablename eq "" || $s_condition eq "");

   my $query = "SELECT * FROM $s_tablename WHERE $s_condition;";
   my $results = get_db_handler()->prepare($query);
   my $_results = $results->execute() or die $DBI::errstr;

   if ($_results < 0) {
      print $DBI::errstr;
   }

   print "printing all rows where $s_condition \n";
   while (my @row = $results->fetchrow_array()) {
      print "@row\n";
   }

}

sub get_col_from_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_col = $hr_params->{"column"};

   die "cannot fetch column: must provide 'table_name' and 'column'!\n"
      if ($s_tablename eq "" || $s_col eq "");

   my $query = "SELECT $s_col FROM $s_tablename;";
   my $results = get_db_handler()->prepare($query);
   my $_results = $results->execute() or die $DBI::errstr;

   if ($_results < 0) {
      print $DBI::errstr;
   }

   print "printing entries from column $s_col: \n";
   while (my @row = $results->fetchrow_array()) {
      print "@row\n";
   }
}

sub update_row_in_table {
   # update ... set ... where ...
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_col = $hr_params->{"col"};
   my $s_new_value = $hr_params->{"new_value"};
   my $s_condition = $hr_params->{"condition"}; 

   die "cannot update row: must provide 'table_name', 'col', 'new_value' and 'condition'!\n"
      if ($s_tablename eq "" || $s_col eq "" || $s_new_value eq "" || $s_condition eq "");
      
   my $query = "UPDATE $s_tablename
               SET $s_col = '$s_new_value'
               WHERE $s_condition;";

   get_db_handler()->prepare($query)->execute() or die $DBI::errstr;
   print "updated colum '$s_col' with new value '$s_new_value' in table '$s_tablename'\n";
}

# sub add_storage_to_vm {
#    my ($self, $hr_params) = @_;

# }

return 1;