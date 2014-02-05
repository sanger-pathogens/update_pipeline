package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameFormat;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'mate_filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment mate filename format error' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;