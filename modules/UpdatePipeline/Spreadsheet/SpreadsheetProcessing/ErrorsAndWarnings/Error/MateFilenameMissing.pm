package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameMissing;

# Note: Error only occurs if mate filename is missing after path removal

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'mate_filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment mate filename not supplied' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;