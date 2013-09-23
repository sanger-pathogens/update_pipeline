package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleAccessionFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'sample_accession' );

sub _build_error_list
{
    my ($self) = @_;

    return [] unless defined $self->cell_data; # allow to be empty

    my @error_list = ();

    if($self->cell_data =~ m/^\W+$/)
    {
        # non-word in accession
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleAccessionFormat->new( row => $self->row );
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;