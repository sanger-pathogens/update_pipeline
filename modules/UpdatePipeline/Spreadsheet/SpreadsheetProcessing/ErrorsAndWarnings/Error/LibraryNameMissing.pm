package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::LibraryNameMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'library_name'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'library name not supplied' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;