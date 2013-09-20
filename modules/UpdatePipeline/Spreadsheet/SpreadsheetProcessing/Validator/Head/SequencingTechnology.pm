package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SequencingTechnologyMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SequencingTechnologyUnknown;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'sequencing_technology' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    if(!defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SequencingTechnologyMissing->new();
    }
    elsif($self->cell_data !~ m/^illumina|454|slx$/i)
    {
        # tech is not illumina or 454
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SequencingTechnologyUnknown->new();
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;