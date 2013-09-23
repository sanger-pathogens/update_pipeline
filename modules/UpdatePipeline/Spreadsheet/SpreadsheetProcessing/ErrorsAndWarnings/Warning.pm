package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Base';

has 'description' => ( is => 'ro', isa => 'Str', default => 'warning' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;