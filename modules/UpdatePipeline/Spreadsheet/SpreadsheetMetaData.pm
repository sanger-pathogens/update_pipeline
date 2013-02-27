=head1 NAME

SpreadsheetMetaData.pm   - Container with header and rows from spreadsheet, which get validated as they are passed in.

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::SpreadsheetMetaData;
my $spreadsheet = UpdatePipeline::Spreadsheet::SpreadsheetMetaData->new(
  input_header => (
                   supplier_name                  => 'John Doe',
                   supplier_organisation          => 'Somewhere',
                   internal_contact               => 'Jane Doe',
                   sequencing_technology          => 'Illumina',
                   study_name                     => 'My Study Name',
                   study_accession_number         => 'ERS123',
                   total_size_of_files_in_gbytes  => '2.2',
                   data_to_be_kept_until          => '2013-01-23',
                 ),
  raw_rows => (
                {
                  filename                => 'myfile.fastq.gz', 
                  mate_filename           => undef,
                  sample_name             => '1',
                  sample_accession_number => undef,
                  taxon_id                => 589363,
                  library_name            => 'L5_AB_12_2011',
                  fragment_size             => 200,
                  raw_read_count          => undef,
                  raw_base_count          => 316211200,
                  comments                => undef
                },.....
              ),
);
$spreadsheet->files_metadata;

=cut

package UpdatePipeline::Spreadsheet::SpreadsheetMetaData;
use Moose;
use Moose::Util::TypeConstraints;
use UpdatePipeline::Spreadsheet::Validate::Header;
use UpdatePipeline::Spreadsheet::Validate::SequencingExperiments;
use UpdatePipeline::Spreadsheet::HeaderMetaData;
use UpdatePipeline::Spreadsheet::SequencingExperimentMetaData;
use UpdatePipeline::FileMetaData;
use NCBI::TaxonLookup;

subtype 'Header'
     => as 'HashRef'
     => where { UpdatePipeline::Spreadsheet::Validate::Header->new( input_header => $_ )->is_valid() }
     => message { "$_ is not a valid Header" };
     
subtype 'SequencingExperiments'
     => as 'ArrayRef'
     => where { UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new( raw_rows => $_ )->is_valid() }
     => message { "$_ contains invalid data in the sequencing experiments rows" };

# inputs
has 'input_header'            => ( is => 'ro', isa => 'Header',                required => 1 );
has 'raw_rows'                => ( is => 'ro', isa => 'SequencingExperiments', required => 1 );
has 'files_base_directory'    => ( is => 'ro', isa => 'Maybe[Str]');

# lazy_build
has '_header'                 => ( is => 'ro', isa => 'UpdatePipeline::Spreadsheet::HeaderMetaData',               lazy_build => 1 );
has '_sequencing_experiments' => ( is => 'ro', isa => 'ArrayRef[UpdatePipeline::Spreadsheet::SequencingExperimentMetaData]', lazy_build => 1 );
has 'files_metadata'          => ( is => 'ro', isa => 'ArrayRef[UpdatePipeline::FileMetaData]',                              lazy_build => 1 );

sub _build__header
{
  my ($self) = @_;
  UpdatePipeline::Spreadsheet::HeaderMetaData->new($self->input_header);
}

sub _build__sequencing_experiments
{
  my ($self) = @_;
  my @sequencing_experiements_array;
  for my $raw_row (@{$self->raw_rows})
  {
     push(@sequencing_experiements_array, UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new($raw_row));
  } 
  return \@sequencing_experiements_array;
}

sub _build_files_metadata
{
  my ($self) = @_;
  my @files_metadata;
  my $file_type = 'fastq.gz';
  
  for my $sequencing_experiment (@{$self->_sequencing_experiments})
  {
  
    $sequencing_experiment->populate_file_locations_on_disk($self->files_base_directory);
    
    my $file_metadata = UpdatePipeline::FileMetaData->new(
      file_type                        => $file_type,
      file_name                        => $sequencing_experiment->pipeline_filename,
      file_name_without_extension      => $self->_file_name_without_extension($sequencing_experiment->pipeline_filename,$file_type),
      mate_file_type                   => (defined($sequencing_experiment->mate_filename)) ? $file_type : undef,
      mate_file_name                   => $sequencing_experiment->pipeline_mate_filename,
      mate_file_name_without_extension => $self->_file_name_without_extension($sequencing_experiment->pipeline_mate_filename,$file_type),
      total_reads                      => $sequencing_experiment->raw_read_count,
      lane_is_paired_read              => (defined($sequencing_experiment->mate_filename)) ? 1 : 0,
      lane_manual_qc                   => '-',
      library_name                     => $sequencing_experiment->library_name,
      fragment_size_from               => $sequencing_experiment->fragment_size,
      fragment_size_to                 => $sequencing_experiment->fragment_size,
      sample_name                      => $sequencing_experiment->sample_name,
      sample_accession_number          => $sequencing_experiment->sample_accession_number,
      sample_common_name               => NCBI::TaxonLookup->new(taxon_id => $sequencing_experiment->taxon_id)->common_name,
      study_name                       => $self->_header->study_name,
      study_accession_number           => $self->_header->study_accession_number,
    );
    push(@files_metadata, $file_metadata);
  }

  return \@files_metadata;
}

sub _file_name_without_extension
{
   my ($self, $input_filename, $input_file_type) = @_;
   return undef unless(defined($input_filename) && defined($input_file_type));
   $input_filename =~ s!.$input_file_type!!;
   $input_filename =~ s!\_1$!!;
   $input_filename =~ s!\_2$!!;
   return $input_filename;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
