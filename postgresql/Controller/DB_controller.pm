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

sub create_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   my $query = "CREATE TABLE $s_tablename (
   );";
   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully created table '$s_tablename'\n";
}

sub delete_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   my $query = "DROP TABLE $s_tablename;";
   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully deleted table '$s_tablename'\n";
}

sub add_column_to_table {
   my ($self, $table_name, $hr_params) = @_;
   my $s_colName = $hr_params->{"col_name"};
   my $s_dataType = $hr_params->{"data_type"};
   my $s_constraint = $hr_params->{"constraint"};

   my $query = "ALTER TABLE $table_name
               ADD COLUMN $s_colName $s_dataType $s_constraint;";
   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully added column '$s_colName' to table '$table_name'\n";

}

sub delete_column_from_table {
   my ($self, $table_name, $hr_params) = @_;
   my $s_colName = $hr_params->{"col_name"};

   my $query = "ALTER TABLE $table_name DROP COLUMN $s_colName;";
   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "Successfully deleted column '$s_colName' from table '$table_name'\n";

}

sub get_table {
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};

   my $query = "SELECT * FROM $s_tablename;";
   my $results = $o_db_handler->prepare($query);
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

   if ($s_tablename eq "vm") {
      my $s_os = $hr_params->{"os"};
      $query = "INSERT INTO $s_tablename (name, operating_system, checksum, created_on, last_modified)
                  VALUES ('$s_name', '$s_os', '$s_checksum', '$s_created_on', '$s_created_on');";

   } elsif ($s_tablename eq "storage") {
      my $s_capacity = $hr_params->{"capacity"};
      $query = "INSERT INTO $s_tablename (name, capacity, created_on, last_modified)
                  VALUES ('$s_name', '$s_capacity', '$s_created_on', '$s_created_on');";
   }

   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "row successfully added to table '$s_tablename'\n";
}

sub delete_row_from_table {
   # delete from ... where ... (name/id/...)
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_name = $hr_params->{"name"};
   my $s_id = $hr_params->{"id"};
   my $query = "";

   if ($s_name ne "") {
      $query = "DELETE FROM $s_tablename WHERE name='$s_name';" 
   } elsif ($s_id ne "") {
      $query = "DELETE FROM $s_tablename WHERE id='$s_id';" 
   }

   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "row successfully removed from table '$s_tablename'\n";
}

sub get_rows_from_table {
   # ...
   my ($self, $hr_params) = @_;
   my $s_tablename = $hr_params->{"table_name"};
   my $s_condition = $hr_params->{"condition"};

   my $query = "SELECT * FROM $s_tablename WHERE $s_condition;";
   my $results = $o_db_handler->prepare($query);
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

   my $query = "SELECT $s_col FROM $s_tablename;";
   my $results = $o_db_handler->prepare($query);
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
   my $query = "UPDATE $s_tablename
               SET $s_col = '$s_new_value'
               WHERE $s_condition;";

   $o_db_handler->prepare($query)->execute() or die $DBI::errstr;
   print "updated colum '$s_col' with new value '$s_new_value' in table '$s_tablename'\n";
}

return 1;