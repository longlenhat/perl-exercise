use diagnostics; # this gives you more debugging information
# use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Test::More qw( no_plan ); # for the is() and isnt() functions
use FindBin qw($Bin);
use lib "$Bin/Controller";
use lib "$Bin/Model";
use DB_controller;
use DBI;
use VirtualMachine;
use Storage;

# is(EXPERIMENTAL_VALUE, EXPECTED_VALUE, OPTIONAL_MESSAGE)
# isnt(EXPERIMENTAL_VALUE, EXPECTED_VALUE, OPTIONAL_MESSAGE)

# my $drh = DBI->install_driver('Mock');

my $dbh = DBI->connect(
      "DBI:Mock:dbname=virtual_machines;host='127.0.0.1';port='5432'", # db name and host
      "postgres", # uname
      "postgres", #pw
) or die $DBI::errstr;

my $db_controller = DB_controller->new({"db_name"=>"virtual_machines"});
$db_controller->set_db_handler($dbh);

my $o_vm1 = VirtualMachine->new(
   "name" => "vm1",
   "os" => "ubuntu",
);

# ---------------------------------------------------------------------------
# ----------------------------- TESTS ---------------------------------------
# ---------------------------------------------------------------------------

use_ok("DB_controller", "Loaded DB_controller");

ok($db_controller, "connected mock DB");

# ok($db_controller->get_table({"table_name"=>"test_table"}), "read table ok");
# create table
ok($db_controller->create_table({"table_name"=>"test_table"}), "create table ok");
# delete table
ok($db_controller->delete_table({"table_name"=>"test_table"}), "delete table ok");
# add column
ok($db_controller->add_column_to_table({
      "table_name" => "test_table",
      "col_name" => "name",
      "data_type" => "VARCHAR (25)",
      "constraint" => "NOT NULL"}), "add column ok");
# delete column
ok($db_controller->delete_column_from_table({
      "table_name" => "test_table",
      "col_name" => "name"}), "delete column ok");
# add row to table
ok($db_controller->add_row_to_table("vm",$o_vm1), "add row ok");
# update row
ok($db_controller->update_row_in_table({
    "table_name" => "vm",
    "col" => "name",
    "new_value" => "vm16",
    "condition" => "id=26"
}), "update row ok");