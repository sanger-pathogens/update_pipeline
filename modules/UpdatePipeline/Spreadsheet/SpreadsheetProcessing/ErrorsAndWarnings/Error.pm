package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Base';

has 'fatal' => ( is => 'rw', isa => 'Bool', default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;