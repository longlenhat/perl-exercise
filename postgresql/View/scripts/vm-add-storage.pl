#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../Controller";
use lib "$Bin/../../Model";
use DB_controller;

read(STDIN, my $s_form_data, $ENV{'CONTENT_LENGTH'});
my @a_form_field = split(/&/, $s_form_data);
my ($s_field, $s_name, $s_value);
my %h_form;

foreach $s_field (@a_form_field) {
   (my $s_name, my $s_value) = split(/=/, $s_field);
   $s_value =~ tr/+/ /;
   $s_value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
   $s_value =~ s/</&lt;/g;
   $s_value =~ s/>/&gt;/g;
   $h_form{$s_name} = $s_value;
}

my $o_db_controller = DB_controller->new({"db_name" => "virtual_machines"});


print qq(Content-type: text/html\n\n);

eval {
   $o_db_controller->add_storage_to_vm(
      {
         "name" => $h_form{"storage"}
      },
      {
         "name" => $h_form{"vm"}
      }
   );
   print '<meta http-equiv="refresh" content="2;url=/scripts/db-app.pl" />';
};
if ($@) {
   print "$@\n";
   print "<br>";
   print "redirecting in 5s...\n";
   print '<meta http-equiv="refresh" content="5;url=/scripts/db-app.pl" />';
}
