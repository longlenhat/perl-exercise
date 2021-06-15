package Column;
use strict;
use warnings;

sub new {
    my ($class, %hr_params) = @_;
    my $self = {
        "col_name" => $hr_params{"col_name"},
        "data_type" => $hr_params{"data_type"},
        "constraint" => $hr_params{"constraint"},
    };
    return bless $self, $class;
}

return 1;