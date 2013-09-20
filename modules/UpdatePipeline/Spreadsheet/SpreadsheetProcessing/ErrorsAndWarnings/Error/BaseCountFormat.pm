package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::BaseCountFormat;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'raw_base_count'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'base count is not an integer' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;