package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::SupplierNameMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'supplier_name'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'supplier name not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;