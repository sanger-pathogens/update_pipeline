package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameMissing;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'filename' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data )
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameMissing->new( row => $self->row );
        return \@error_list;
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;