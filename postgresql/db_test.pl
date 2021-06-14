use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__) . "/Controller";
use DB_controller;

DB_controller->create_table(
    "tablename" => "test_table", 
    "os" => "ubuntu",
);
