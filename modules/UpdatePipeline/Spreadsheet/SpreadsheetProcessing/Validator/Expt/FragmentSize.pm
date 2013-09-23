package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::FragmentSizeMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FragmentSizeFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'library_name' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data )
    {
        # not defined (warning)
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::FragmentSizeMissing->new( row => $self->row );
        return \@error_list;
    }
    
    if( $self->cell_data !~ m/^\d+$/ )
    {
        # not integer
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FragmentSizeFormat->new( row => $self->row );        
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;