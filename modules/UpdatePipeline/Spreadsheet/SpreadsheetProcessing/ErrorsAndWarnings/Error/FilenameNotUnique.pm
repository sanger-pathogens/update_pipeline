package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameNotUnique;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment filename not unique' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;