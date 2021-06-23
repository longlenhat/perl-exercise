#!/usr/bin/perl

use strict;
use warnings;
use HTML::Template;
use FindBin qw($Bin);
use lib "$Bin/../../Controller";
use lib "$Bin/../../View";
use DB_controller;
use Data::Dumper;

my $template     = HTML::Template->new(filename => '../db-webapp.html');
my $o_db_handler = DB_controller->new({"db_name" => "virtual_machines"});

################################################ get table
sub get_table() {

   my ($ar_col_names_vm, $ar_col_entries_vm) =
      $o_db_handler->get_table({"table_name" => "vm"});

   my ($ar_col_names_stor, $ar_col_entries_stor) =
      $o_db_handler->get_table({"table_name" => "storage"});


   my @a_cols_vm      = @$ar_col_names_vm;
   my @a_entries_vm   = @$ar_col_entries_vm;
   my @a_cols_stor    = @$ar_col_names_stor;
   my @a_entries_stor = @$ar_col_entries_stor;

   # loop through column names (header)
   my @a_col_names = ();
   my @a_copy_vm   = @a_cols_vm;
   my @a_copy_stor = @a_cols_stor;

   # column names in vm table
   while (@a_copy_vm) {
      my %h_row_data = ();
      $h_row_data{COL_VM} = shift @a_copy_vm;
      push(@a_col_names, \%h_row_data);
   }

   # column names in storage table
   while (@a_copy_stor) {
      my %h_row_data = ();
      $h_row_data{COL_STOR} = shift @a_copy_stor;
      push(@a_col_names, \%h_row_data);
   }

   # loop through column entries
   my @a_col_rows = ();
   @a_copy_vm   = @a_entries_vm;
   @a_copy_stor = @a_entries_stor;

   # entries in vm table
   while (@a_copy_vm) {
      my @a_row        = splice(@a_copy_vm, 0, scalar @a_cols_vm);
      my %h_row_data   = ();
      my @a_row_values = ();

      while (@a_row) {
         my %h_col_value = ();
         $h_col_value{COL_VALUE} = shift @a_row;

         push(@a_row_values, \%h_col_value);
      }

      $h_row_data{ROW_VM} = \@a_row_values;

      push(@a_col_rows, \%h_row_data);
   }


   # entries in vm table
   while (@a_copy_stor) {
      my @a_row        = splice(@a_copy_stor, 0, scalar @a_cols_stor);
      my %h_row_data   = ();
      my @a_row_values = ();

      while (@a_row) {
         my %h_col_value = ();
         $h_col_value{COL_VALUE} = shift @a_row;

         push(@a_row_values, \%h_col_value);
      }

      $h_row_data{ROW_STOR} = \@a_row_values;

      push(@a_col_rows, \%h_row_data);
   }

   $template->param(COL_NAMES => \@a_col_names);
   $template->param(ROWS_LOOP => \@a_col_rows);
}

sub get_cur_items_in_db {
   my @a_vm_entries = $o_db_handler->get_col_from_table(
      {
         "table_name" => "vm",
         "column"     => "name"
      }
   );
   my @a_stor_entries = $o_db_handler->get_col_from_table(
      {
         "table_name" => "storage",
         "column"     => "name"
      }
   );


   # loop through column "names" in vm
   my @a_col_names = ();
   while (@a_vm_entries) {
      my %h_row_data = ();
      $h_row_data{VM} = shift @a_vm_entries;
      push(@a_col_names, \%h_row_data);
   }

   # loop through column "names" in storage
   while (@a_stor_entries) {
      my %h_row_data = ();
      $h_row_data{STOR} = shift @a_stor_entries;
      push(@a_col_names, \%h_row_data);
   }

   $template->param(CUR_ITEMS => \@a_col_names);
}

get_table();
get_cur_items_in_db();

################################################

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $template->output;
