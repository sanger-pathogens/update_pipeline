package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment;
use Moose;

has 'experiment_row'           => ( is => 'ro', isa => 'HashRef',    required => 1);
has 'valid_experiment_row'     => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_filename'                => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_mate_filename'           => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_sample_name'             => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_sample_accession_number' => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_taxon_id'                => ( is => 'ro', isa => 'Int',        lazy_build => 1);
has '_library_name'            => ( is => 'ro', isa => 'Str',        lazy_build => 1);
has '_fragment_size'           => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_raw_read_count'          => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_raw_base_count'          => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_comments'                => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);

sub _build_valid_experiment_row
{
    my ($self) = @_;
    my %experiment_row = ( 'filename'                => $self->_filename,
			   'mate_filename'           => $self->_mate_filename,
			   'sample_name'             => $self->_sample_name,
			   'sample_accession_number' => $self->_sample_accession_number,
			   'taxon_id'                => $self->_taxon_id,
			   'library_name'            => $self->_library_name,
			   'fragment_size'           => $self->_fragment_size,
			   'raw_read_count'          => $self->_raw_read_count,
			   'raw_base_count'          => $self->_raw_base_count,
			   'comments'                => $self->_comments );
    return \%experiment_row;
}

sub _build__filename
{
    my ($self) = @_;
    return $self->experiment_row->{'filename'};
}

sub _build__mate_filename
{
    my ($self) = @_;
    return $self->experiment_row->{'mate_filename'};
}

sub _build__sample_name
{
    my ($self) = @_;
    return $self->experiment_row->{'sample_name'};
}

sub _build__sample_accession_number
{
    my ($self) = @_;
    return $self->experiment_row->{'sample_accession_number'};
}

sub _build__taxon_id
{
    my ($self) = @_;
    return $self->experiment_row->{'taxon_id'};
}

sub _build__library_name
{
    my ($self) = @_;
    return $self->experiment_row->{'library_name'};
}

sub _build__fragment_size
{
    my ($self) = @_;
    return $self->experiment_row->{'fragment_size'};
}

sub _build__raw_read_count
{
    my ($self) = @_;
    return $self->experiment_row->{'raw_read_count'};
}

sub _build__raw_base_count
{
    my ($self) = @_;
    return $self->experiment_row->{'raw_base_count'};
}

sub _build__comments
{
    my ($self) = @_;
    return $self->experiment_row->{'comments'};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
