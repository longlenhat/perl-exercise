use strict;
use warnings;
use DBI;

package DB_controller;

my $s_dbname = "virtual_machines";
my $s_hostname = "127.0.0.1";
my $s_port = "5432";
my $s_username = "postgres";
my $s_password = "postgres";

# connection config
my $o_dbHandler = DBI->connect(
    "dbi:Pg:dbname=$s_dbname;host=$s_hostname;port=$s_port", # db name and host
    $s_username, # uname
    $s_password, #pw
);

sub create_table {
    my ($self, %args) = shift @_;
    my $s_tablename = $args{"tablename"};
    my $s_os = $args{"os"};
    my $s_stor = $args{"stor"};
    my $s_checksum = $args{"checksum"};

    my $query = "CREATE TABLE IF NOT EXISTS test_table (

    );";

    my $result = $o_dbHandler->prepare($query);
    $result->execute();

    print "$s_tablename\n";
}

return 1;