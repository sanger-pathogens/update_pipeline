package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::ReadCountMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::ReadCountFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'raw_read_count' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::ReadCountMissing->new( row => $self->row );
        return \@error_list;
    }
    
    if( $self->cell_data !~ m/^\d+$/ )
    {
        # not integer
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::ReadCountFormat->new( row => $self->row );        
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;