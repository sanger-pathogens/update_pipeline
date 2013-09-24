package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameLeadTrailSpace;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment mate filename lead/trail space' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;