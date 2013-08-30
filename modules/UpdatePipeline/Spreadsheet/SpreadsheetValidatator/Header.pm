package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header;
use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Common';

has 'header'                         => ( is => 'ro', isa => 'HashRef',    required => 1);
has 'valid_header'                   => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_supplier_name'                 => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_supplier_organisation'         => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_internal_contact'              => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_sequencing_technology'         => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_study_name'                    => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_study_accession_number'        => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_total_size_of_files_in_gbytes' => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_data_to_be_kept_until'         => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);

sub _build_valid_header
{
    my ($self) = @_;
    my %header = ( 'supplier_name'                 => $self->_supplier_name,
                   'supplier_organisation'         => $self->_supplier_organisation,
                   'internal_contact'              => $self->_internal_contact,
                   'sequencing_technology'         => $self->_sequencing_technology,
                   'study_name'                    => $self->_study_name,
                   'study_accession_number'        => $self->_study_accession_number,
                   'total_size_of_files_in_gbytes' => $self->_total_size_of_files_in_gbytes,
                   'data_to_be_kept_until'         => $self->_data_to_be_kept_until );
    return \%header;
}

sub _build__cell_data
{
    my ($self) = @_;
    return $self->header;
}

sub _build__cell_title
{
    my ($self) = @_;
    my %cell = ( 'supplier_name'                 => 'Supplier Name',
                 'supplier_organisation'         => 'Supplier Organisation',
                 'internal_contact'              => 'Sanger Contact Name',
                 'sequencing_technology'         => 'Sequencing Technology',
                 'study_name'                    => 'Study Name',
                 'study_accession_number'        => 'Study Accession Number',
                 'total_size_of_files_in_gbytes' => 'Size of files (GBytes)',
                 'data_to_be_kept_until'         => 'Data retained until' );
    return \%cell;
}

sub _build__cell_allowed_status
{
    my ($self) = @_;
    my %cell = ( 'supplier_name'                 => ['string','blank','empty'],
                 'supplier_organisation'         => ['string','blank','empty'],
                 'internal_contact'              => ['string','blank','empty'],
                 'sequencing_technology'         => ['string'],
                 'study_name'                    => ['string'],
                 'study_accession_number'        => ['integer','undefined'],
                 'total_size_of_files_in_gbytes' => ['number','integer','empty','undefined'],
                 'data_to_be_kept_until'         => ['date','integer','empty','undefined'] );
    return \%cell;
}

sub _build__supplier_name
{
    my ($self) = @_;
    return $self->_cell_data->{'supplier_name'} if $self->_process_cell('supplier_name');

    print " setting supplier name to empty string\n";
    return '';
}

sub _build__supplier_organisation
{
    my ($self) = @_;
    return $self->_cell_data->{'supplier_organisation'} if $self->_process_cell('supplier_organisation');

    print " setting supplier name to empty string\n";
    return '';
}

sub _build__internal_contact
{
    my ($self) = @_;
    return $self->_cell_data->{'internal_contact'} if $self->_process_cell('internal_contact');
    
    print " setting internal contact to empty string\n";
    return '';
}

sub _build__sequencing_technology
{
    my ($self) = @_;
    $self->_process_cell('sequencing_technology');

    if( $self->_cell_data->{'sequencing_technology'} !~ m/illumina|454|slx/gi )
    {
        print " error: sequencing technology '",$self->_cell_data->{'sequencing_technology'},"' not recognised.\n";
        print " setting sequencing technology to default, 'Illumina'\n";
        return 'Illumina';
    }

    return $self->_cell_data->{'sequencing_technology'};
}

sub _build__study_name
{
    my ($self) = @_;
    return $self->_cell_data->{'study_name'} if $self->_process_cell('study_name');

    print " fatal error: study name not supplied\n";
    return undef; 
}

sub _build__study_accession_number
{
    my ($self) = @_;
    return $self->_cell_data->{'study_accession_number'} if $self->_process_cell('study_accession_number');

    print " setting study accession to undef\n";
    return undef;
}

sub _build__total_size_of_files_in_gbytes
{
    my ($self) = @_;
    $self->_process_cell('total_size_of_files_in_gbytes');
    return $self->_cell_data->{'total_size_of_files_in_gbytes'};
}

sub _build__data_to_be_kept_until
{
    my ($self) = @_;
    $self->_process_cell('data_to_be_kept_until');
    return $self->_cell_data->{'data_to_be_kept_until'};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
