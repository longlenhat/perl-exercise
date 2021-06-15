package Table;
use strict;
use warnings;

my %columns = ();

sub new {
    my ($class, %hr_params) = @_;
    my $self = {
        "table_name" => $hr_params{"table_name"},
    };
    return bless $self, $class;
}

sub add_col {
    my ($self, $hr_params) = @_;
    $columns{$hr_params->{"col_name"}} = $hr_params;
}

sub get_col_by_name {
    my ($self, $query) = @_;
    return $columns{$query};
}

return 1;