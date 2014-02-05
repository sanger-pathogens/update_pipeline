package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::DateMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'data_to_be_kept_until' );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'date not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;