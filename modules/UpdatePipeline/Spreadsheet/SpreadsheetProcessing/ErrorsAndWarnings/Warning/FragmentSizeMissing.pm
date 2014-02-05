package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::FragmentSizeMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'fragment_size'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'fragment size not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;