#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw($Bin);
use lib "$Bin/../../Controller";
use lib "$Bin/../../Model";
use DB_controller;
use VirtualMachine;

# parsing and reading the input forms
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

my $o_vm1 = VirtualMachine->new(
   "name" => $h_form{'name'},
   "os"   => $h_form{'os'},
);

print qq(Content-type: text/html\n\n);
eval {
   $o_db_controller->add_row_to_table("vm", $o_vm1);
   print "<br>";
   print "Redirecting...";
   print '<meta http-equiv="refresh" content="1.5;url=/scripts/db-app.pl" />';
};
if ($@) {    # printing error
   print "$@\n";
   print "<br>";
   print "redirecting in 5s...\n";
   print '<meta http-equiv="refresh" content="5;url=/scripts/db-app.pl" />';
}
