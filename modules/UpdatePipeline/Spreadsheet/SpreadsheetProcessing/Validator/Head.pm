package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head;

use Moose;

use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierName;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierOrganisation;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SangerContact;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyName;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date;

has 'header_metadata' => ( is => 'ro', isa => 'HashRef',  required   => 1 );
has 'error_list'      => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

sub _build_error_list
{
    my ($self) = @_;

    my @error_list = ();
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierName->new( cell_data => $self->header_metadata->{'supplier_name'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierOrganisation->new( cell_data => $self->header_metadata->{'supplier_organisation'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SangerContact->new( cell_data => $self->header_metadata->{'internal_contact'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology->new( cell_data => $self->header_metadata->{'sequencing_technology'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyName->new( cell_data => $self->header_metadata->{'study_name'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession->new( cell_data => $self->header_metadata->{'study_accession_number'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size->new( cell_data => $self->header_metadata->{'total_size_of_files_in_gbytes'})->error_list };
    push @error_list, @{ UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date->new( cell_data => $self->header_metadata->{'data_to_be_kept_until'})->error_list };

    return \@error_list;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;