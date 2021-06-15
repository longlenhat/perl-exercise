#!/usr/bin/env perl
use strict;
use warnings;
# use File::Basename;
# use lib dirname (__FILE__) . "/Controller";
use FindBin qw ($Bin);
use lib "$Bin/Controller";
use lib "$Bin/Model";
use DB_controller;
use Table; 
use Column;

my $o_db_controller = DB_controller->new({"db_name" => "virtual_machines"});
my $o_table1 = Table->new("table_name" => "test_table");
my $o_col_name = Column->new(
    "col_name" => "name",
    "data_type" => "VARCHAR (25)",
    "constraint" => "NOT NULL"
);

$o_table1->add_col($o_col_name);

$o_db_controller->delete_table($o_table1);
$o_db_controller->create_table($o_table1);
$o_db_controller->add_column_to_table("test_table", $o_col_name);
$o_db_controller->delete_column_from_table("test_table", $o_col_name);

# print ($INC{"DB_controller.pm"},"\n");