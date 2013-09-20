package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::BaseCountMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::BaseCountFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'raw_base_count' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::BaseCountMissing->new();
        return \@error_list;
    }
    
    if( $self->cell_data !~ m/^\d+$/ )
    {
        # not integer
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::BaseCountFormat->new();        
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;