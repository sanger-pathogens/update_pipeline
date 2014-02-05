package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierOrganisation;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SupplierOrganisationMissing;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'supplier_organisation' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    if(!defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SupplierOrganisationMissing->new();
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;