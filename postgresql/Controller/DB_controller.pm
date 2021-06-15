#!/usr/bin/env perl
package DB_controller;

use strict;
use warnings;
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
    );

    return bless {"db_name" => $s_dbname}, $self;
}

# returns db_handler if needed
sub get_db_handler {
    return $o_db_handler;
}

sub create_table {
    my ($self, $hr_params) = @_;
    my $s_tablename = $hr_params->{"table_name"};

    my $query = "CREATE TABLE IF NOT EXISTS $s_tablename (
    );";
    $o_db_handler->prepare($query)->execute();
}

sub delete_table {
    my ($self, $hr_params) = @_;
    my $s_tablename = $hr_params->{"table_name"};

    my $query = "DROP TABLE IF EXISTS $s_tablename;";
    my $result = $o_db_handler->prepare($query);
    $result->execute();
}

sub add_column_to_table {
    my ($self, $table_name, $hr_params) = @_;
    my $s_colName = $hr_params->{"col_name"};
    my $s_dataType = $hr_params->{"data_type"};
    my $s_constraint = $hr_params->{"constraint"};

    my $query = "ALTER TABLE $table_name
                ADD COLUMN $s_colName $s_dataType $s_constraint;";
    $o_db_handler->prepare($query)->execute();
}

sub delete_column_from_table {
    my ($self, $table_name, $hr_params) = @_;
    my $s_colName = $hr_params->{"col_name"};

    my $query = "ALTER TABLE $table_name DROP COLUMN $s_colName;";
    $o_db_handler->prepare($query)->execute();
}

return 1;