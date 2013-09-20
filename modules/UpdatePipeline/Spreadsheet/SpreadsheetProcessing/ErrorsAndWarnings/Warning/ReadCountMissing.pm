package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::ReadCountMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'raw_read_count'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'read count not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;