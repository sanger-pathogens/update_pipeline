package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::StudyAccessionFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'study_accession' );

sub _build_error_list
{
    my ($self) = @_;

    return [] unless defined $self->cell_data; # allow to be empty

    my @error_list = ();

    if($self->cell_data !~ m/^\w+$/)
    {
        # non-word in accession
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::StudyAccessionFormat->new();
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;