#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../Controller";
use lib "$Bin/../../Model";
use DB_controller;

read(STDIN, my $s_form_data, $ENV{'CONTENT_LENGTH'});
$s_form_data =~ s/vm=//;

my $o_db_controller = DB_controller->new({"db_name" => "virtual_machines"});

print qq(Content-type: text/html\n\n);

eval {
   $o_db_controller->remove_storage_from_vm(
      {
         "name" => $s_form_data,
      }
   );
   print "<br>";
   print "Redirecting...";
   print '<meta http-equiv="refresh" content="2;url=/scripts/db-app.pl" />';
};
if ($@) {
   print "$@\n";
   print "<br>";
   print "redirecting in 5s...\n";
   print '<meta http-equiv="refresh" content="5;url=/scripts/db-app.pl" />';
}
