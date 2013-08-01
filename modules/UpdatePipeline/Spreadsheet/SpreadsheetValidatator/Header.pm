package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header;
use Moose;

has 'header'                         => ( is => 'ro', isa => 'HashRef',    required => 1);
has 'valid_header'                   => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_cell'                          => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_supplier_name'                 => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_supplier_organisation'         => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_internal_contact'              => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_sequencing_technology'         => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_study_name'                    => ( is => 'ro', isa => 'Str',        lazy_build => 1);
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

sub _build__cell
{
    my ($self) = @_;
    my %cell = ( 'supplier_name'                 => 'Supplier Name',
                 'supplier_organisation'         => 'Supplier Organisation',
                 'internal_contact'              => 'Sanger Contact Name',
                 'sequencing_technology'         => 'Sequencing Technology',
                 'study_name'                    => 'Study Name',
                 'study_accession_number'        => 'Study Accession number',
                 'total_size_of_files_in_gbytes' => 'Total size of files in GBytes',
                 'data_to_be_kept_until'         => 'Data to be kept until' );
    return \%cell;
}

sub _build__supplier_name
{
    my ($self) = @_;
    return $self->header->{'supplier_name'};
}

sub _build__supplier_organisation
{
    my ($self) = @_;
    return $self->header->{'supplier_organisation'};
}

sub _build__internal_contact
{
    my ($self) = @_;
    return $self->header->{'internal_contact'};
}

sub _build__sequencing_technology
{
    my ($self) = @_;
    return $self->header->{'sequencing_technology'};
}

sub _build__study_name
{
    my ($self) = @_;
    return $self->header->{'study_name'};
}

sub _build__study_accession_number
{
    my ($self) = @_;
    return $self->header->{'study_accession_number'};
}

sub _build__total_size_of_files_in_gbytes
{
    my ($self) = @_;
    return $self->header->{'total_size_of_files_in_gbytes'};
}

sub _build__data_to_be_kept_until
{
    my ($self) = @_;
    return $self->header->{'data_to_be_kept_until'};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
