package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::BaseCountMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'raw_base_count'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'base count not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;