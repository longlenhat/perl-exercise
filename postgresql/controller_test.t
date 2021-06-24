use diagnostics;                 # this gives you more debugging information
use warnings;                    # this warns you of bad practices
use strict;                      # this prevents silly errors
use Test::More qw( no_plan );    # for the is() and isnt() functions
use Test::Exception;
use FindBin qw($Bin);
use lib "$Bin/Controller";
use lib "$Bin/Model";
use DB_controller;
use VirtualMachine;
use Storage;

# is(EXPERIMENTAL_VALUE, EXPECTED_VALUE, OPTIONAL_MESSAGE)
# isnt(EXPERIMENTAL_VALUE, EXPECTED_VALUE, OPTIONAL_MESSAGE)

my $db_controller = DB_controller->new({"db_name" => "test_db"});

my $o_vm1 = VirtualMachine->new(
   "name" => "vm1",
   "os"   => "ubuntu",
);
my $o_sto1 = Storage->new(
   "name"     => "sto1",
   "capacity" => "2024"
);

# ---------------------------------------------------------------------------
# ----------------------------- TESTS ---------------------------------------
# ---------------------------------------------------------------------------

use_ok("DB_controller", "Loaded DB_controller");

##### get table
subtest "testing getting/reading tables" => sub {
   ok($db_controller->get_table({"table_name" => "vm"}), "read table vm ok");
   ok($db_controller->get_table({"table_name" => "vm"}), "read table storage ok");

   dies_ok(sub {$db_controller->get_table()}, "expecting to die due to not providing table name");

   dies_ok(sub {$db_controller->get_table({"table_name" => "non_existing_table"})}, "expecting to die due to table not existing");
};

##### adding/deleting rows
# vm table
subtest "testing adding/deleting vm table" => sub {
   ok($db_controller->add_row_to_table("vm", $o_vm1), "adding row vm ok");
   dies_ok(sub {$db_controller->add_row_to_table("vm", $o_vm1)}, "expecting to die: adding already existing item");
   dies_ok(sub {$db_controller->delete_row_from_table("vm")}, "expecting to die: no object given what to delete");
   dies_ok(sub {$db_controller->delete_row_from_table()}, "expecting to die: nothing passed");
   ok($db_controller->delete_row_from_table("vm", $o_vm1), "deleting row vm ok");
};

# storage table
subtest "testing adding/deleting storage table" => sub {
   ok($db_controller->add_row_to_table("storage", $o_sto1), "adding row storage ok");
   dies_ok(sub {$db_controller->add_row_to_table("storage", $o_sto1)}, "expecting to die: adding already existing item");
   dies_ok(sub {$db_controller->delete_row_from_table("storage")}, "expecting to die: no object given what to delete");
   dies_ok(sub {$db_controller->delete_row_from_table()}, "expecting to die: nothing passed");
   ok($db_controller->delete_row_from_table("storage", $o_sto1), "deleting row ok");
};

##### adding/removing storage to/from vm
$db_controller->add_row_to_table("vm",      $o_vm1);
$db_controller->add_row_to_table("storage", $o_sto1);

subtest "testing linking/deleting storage" => sub {
   ok($db_controller->add_storage_to_vm($o_sto1, $o_vm1), "linking storage to vm ok");
   dies_ok(sub {$db_controller->delete_row_from_table("storage", $o_sto1)}, "expecting to die: cannot delete storage due to it being referenced");
   dies_ok(sub {$db_controller->delete_row_from_table("storage")}, "expecting to die: no storage passed");
   dies_ok(sub {$db_controller->delete_row_from_table()}, "expecting to die: no arguments passed");
   ok($db_controller->remove_storage_from_vm($o_vm1), "removing storage from vm ok");
   ok($db_controller->delete_row_from_table("storage", $o_sto1), "storage can be deleted after reference is removed");
};

##### update row
$db_controller->add_row_to_table("storage", $o_sto1);

dies_ok(sub {$db_controller->update_row_in_table()}, "expecting update to die: no params passed");

# updating vm
subtest "testing updating vm table" => sub {
   ok($db_controller->update_row_in_table({
            "table_name" => "vm",
            "col"        => "operating_system",
            "new_value"  => "debian",
            "condition"  => "name='vm1'"
   }), "updating vm successful");
   dies_ok(sub {$db_controller->update_row_in_table({
               "table_name" => "vm",
               "col"        => "os",
               "new_value"  => "os_not_in_list",
               "condition"  => "name='vm1'"
   })}, "expecting update to vm to die due to value of os not being in the list");
};

# updating storage
subtest "testing updating storage table" => sub {
   ok($db_controller->update_row_in_table({
            "table_name" => "storage",
            "col"        => "capacity",
            "new_value"  => "1234",
            "condition"  => "name='sto1'"
   }), "updating storage successful");
   dies_ok(sub {$db_controller->update_row_in_table({
               "table_name" => "storage",
               "col"        => "capacity",
               "new_value"  => "not_a_number",
               "condition"  => "name='sto1'"
   })}, "expecting update to storage to die due to capacity value not being numeric value");
};

$db_controller->delete_row_from_table("vm",      $o_vm1);
$db_controller->delete_row_from_table("storage", $o_sto1);
