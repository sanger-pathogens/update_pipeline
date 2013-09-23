package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'sample_name' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDMissing->new( row => $self->row );
        return \@error_list;
    }
    
    if( $self->cell_data !~ m/^\d+$/ )
    {
        # not integer
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDFormat->new( row => $self->row );        
    }
    elsif( $self->cell_data == 0 )
    {
        # zero
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::TaxonIDZero->new( row => $self->row ); 
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;