package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SupplierOrganisationMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'supplier_organisation'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'supplier organisation not supplied' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

override 'autofix' => sub {
    my ($self, $cell_data) = @_;    
    return ''; # supplier organisation is required but can be set to empty string
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;