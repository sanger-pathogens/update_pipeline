package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Base';

has 'fatal' => ( is => 'rw', isa => 'Bool', default => 1 ); # 0 indicates potentially fixable. 

# Attempt to automatically fix an error
# Override for individual error types
sub autofix
{
    my ($self, $cell_data) = @_;

    return $cell_data if $self->fatal;

    return undef;  # unset metadata value.
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;