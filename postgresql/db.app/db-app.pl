#!/usr/bin/env perl

use strict;
use warnings;
use HTML::Template;
use FindBin qw($Bin);
use lib "$Bin/../Controller";
use lib "$Bin/../View";

# open the html template
my $template = HTML::Template->new( filename => 'db-webapp.html' );

# fill in some parameters
$template->param( HOME => "doefn" );
$template->param( PATH => $ENV{PATH} );

# send the obligatory Content-Type and print the template output
print "Content-Type: text/html\n\n", $template->output;

# print($INC{"CGI_handler.pm"},"\n");
