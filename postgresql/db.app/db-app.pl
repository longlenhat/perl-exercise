#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Template;
use FindBin qw($Bin);
use lib "$Bin/../Controller";
use lib "$Bin/../View";
use DB_controller;
use Data::Dumper;

my $template     = HTML::Template->new( filename => 'db-webapp.html' );
my $o_db_handler = DB_controller->new( { "db_name" => "virtual_machines" } );

################################################ get table

my ( $ar_col_names, $ar_col_entries ) =
  $o_db_handler->get_table( { "table_name" => "vm" } );

my @a_cols     = @$ar_col_names;
my @a_entries  = @$ar_col_entries;
my $i_num_cols = scalar @a_cols;

# loop through column names (header)
my @a_col_names = ();
my @a_copy      = @a_cols;
while (@a_copy) {
    my %h_row_data = ();
    $h_row_data{COL} = shift @a_copy;
    push( @a_col_names, \%h_row_data );
}

# loop through column entries
my @a_col_rows = ();
@a_copy = @a_entries;
while (@a_copy) {
    my @a_row        = splice( @a_copy, 0, scalar @a_cols );
    my %h_row_data   = ();
    my @a_row_values = ();

    while (@a_row) {
        my %h_col_value = ();
        $h_col_value{COL_VALUE} = shift @a_row;

        push( @a_row_values, \%h_col_value );
    }

    $h_row_data{ROW} = \@a_row_values;

    push( @a_col_rows, \%h_row_data );
}

$template->param( COL_NAMES => \@a_col_names );
$template->param( ROWS_LOOP => \@a_col_rows );

################################################

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $template->output;

# print( $INC{"DB_controller.pm"}, "\n" );
