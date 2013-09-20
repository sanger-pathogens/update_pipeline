package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDFormat;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'taxon_id'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'taxon id not an integer' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;