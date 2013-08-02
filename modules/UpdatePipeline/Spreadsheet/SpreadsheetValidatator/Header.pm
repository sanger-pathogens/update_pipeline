package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header;
use Moose;
use Scalar::Util qw(looks_like_number);

has 'header'                         => ( is => 'ro', isa => 'HashRef',    required => 1);
has 'valid_header'                   => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_cell_title'                    => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_cell_allowed_status'           => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
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

sub _build__cell_title
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

sub _build__cell_allowed_status
{
    my ($self) = @_;
    my %cell = ( 'supplier_name'                 => ['string'],
                 'supplier_organisation'         => ['string'],
                 'internal_contact'              => ['string'],
                 'sequencing_technology'         => ['string'],
                 'study_name'                    => ['string'],
                 'study_accession_number'        => ['integer'],
                 'total_size_of_files_in_gbytes' => ['number','integer'],
                 'data_to_be_kept_until'         => ['date'] );
    return \%cell;
}

sub _build__supplier_name
{
    my ($self) = @_;
    $self->_process_cell('supplier_name');
    return $self->header->{'supplier_name'};
}

sub _build__supplier_organisation
{
    my ($self) = @_;
    $self->_process_cell('supplier_organisation');
    return $self->header->{'supplier_organisation'};
}

sub _build__internal_contact
{
    my ($self) = @_;
    $self->_process_cell('internal_contact');
    return $self->header->{'internal_contact'};
}

sub _build__sequencing_technology
{
    my ($self) = @_;
    $self->_process_cell('sequencing_technology');

    if( $self->header->{'sequencing_technology'} !~ m/illumina|454|slx/gi )
    {
        print " Error: Sequencing technology '",$self->header->{'sequencing_technology'},"' not recognised.\n";
    }

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
    $self->_process_cell('total_size_of_files_in_gbytes');
    return $self->header->{'total_size_of_files_in_gbytes'};
}

sub _build__data_to_be_kept_until
{
    my ($self) = @_;
    $self->_process_cell('data_to_be_kept_until');
    return $self->header->{'data_to_be_kept_until'};
}

sub _get_cell_status
{
    my ($self,$cell) = @_;

    my $status = '';
    if(! exists  $self->header->{$cell})
    { 
        $status = "absent"; 
    }
    elsif(! defined $self->header->{$cell})
    { 
        $status = "undefined"; 
    }
    elsif($self->header->{$cell} eq '' )
    { 
        $status = "blank"; 
    }
    elsif( looks_like_number $self->header->{$cell} )
    { 
        $status = "number";
        $status = "integer" if $self->header->{$cell} =~ m/^\d+$/;
        $status = "zero"    if $self->header->{$cell} == 0;
    }
    elsif( $self->header->{$cell} =~ m/^\d{2}\.\d{2}\.\d{4}$/ )
    {
        $status = "date"; 
    }
    else
    {
        $status = "string";
    }

    return $status;
}

sub _process_cell
{
    my ($self,$cell) = @_;

    my $title   = $self->_cell_title->{$cell};
    my $status  = $self->_get_cell_status($cell);
    my %allowed = map { $_ => 1 } @{$self->_cell_allowed_status->{$cell}};

    my $passed  = $allowed{$status} ? 'ok':'error' ;
    printf "%s is %s %s\n",$title,$status,$passed;

    return $allowed{$status};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
