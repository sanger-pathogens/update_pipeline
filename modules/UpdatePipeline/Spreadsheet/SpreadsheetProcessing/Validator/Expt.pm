package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleName;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::LibraryName;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Comments;


has 'rows_metadata' => ( is => 'ro', isa => 'ArrayRef', required   => 1 );
has 'error_list'    => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    # check hierarchy
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => $self->rows_metadata )->error_list };

    # check individual rows
    my $row = 0;
    for my $expt (@{ $self->rows_metadata })
    {
        $row++;
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => $row, cell_data => $expt->{'filename'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => $row, cell_data => $expt->{'mate_filename'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleName->new( row => $row, cell_data => $expt->{'sample_name'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession->new( row => $row, cell_data => $expt->{'sample_accession_number'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID->new( row => $row, cell_data => $expt->{'taxon_id'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::LibraryName->new( row => $row, cell_data => $expt->{'library_name'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize->new( row => $row, cell_data => $expt->{'fragment_size'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount->new( row => $row, cell_data => $expt->{'raw_read_count'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount->new( row => $row, cell_data => $expt->{'raw_base_count'})->error_list };
        push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Comments->new( row => $row, cell_data => $expt->{'comments'})->error_list };
    }

    return \@error_list;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;