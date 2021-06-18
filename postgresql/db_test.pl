#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/Controller";
use lib "$Bin/Model";

use DB_controller;
use Table; 
use Column;
use VirtualMachine;
use Storage;

my $o_db_controller = DB_controller->new({"db_name" => "virtual_machines"});
my $o_table1 = Table->new("table_name" => "vm");
my $o_col_name = Column->new(
   "col_name" => "name",
   "data_type" => "VARCHAR (25)",
   "constraint" => "NOT NULL"
);

my $o_vm1 = VirtualMachine->new(
   "name" => "vm3",
   "os" => "win",
);

my $o_sto1 = Storage->new(
   "name" => "sto1",
   "capacity" => "1024mb"
);

# print $o_vm1->{"checksum"},"\n";
# print $o_sto1->{"checksum"},"\n";

# $o_table1->add_col($o_col_name);

# $o_db_controller->delete_table($o_table1);
# $o_db_controller->create_table($o_table1);
# $o_db_controller->add_column_to_table("test_table", $o_col_name);
# $o_db_controller->delete_column_from_table("test_table", $o_col_name);

# $o_db_controller->delete_row_from_table("vm", $o_vm1);
$o_db_controller->add_row_to_table("vm", $o_vm1);
$o_db_controller->get_table($o_table1);
# $o_db_controller->add_row_to_table("storage", $o_sto1);

# $o_db_controller->get_rows_from_table({
#     "table_name" => "vm",
#     "condition" => "name='vm32'",
# });

# $o_db_controller->update_row_in_table({
#     "table_name" => "vm",
#     "col" => "name",
#     "new_value" => "vm16",
#     "condition" => "id=26"
# });

# print ($INC{"DB_controller.pm"},"\n");
