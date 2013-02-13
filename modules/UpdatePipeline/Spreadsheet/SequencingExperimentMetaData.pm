=head1 NAME

SequencingExperimentMetaData.pm  - A class to represent the metadata associated with a single sequencing experiment

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::Validate::SequencingExperimentMetaData;

UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new(

);

=cut

package UpdatePipeline::Spreadsheet::SequencingExperimentMetaData;
use Moose;
use Moose::Util::TypeConstraints;
use UpdatePipeline::Exceptions;
use UpdatePipeline::Spreadsheet::SequencingFiles;

has 'filename'                   => ( is => 'ro', isa => 'Str', required   => 1 );
has 'mate_filename'              => ( is => 'ro', isa => 'Maybe[Str]');
has 'sample_name'                => ( is => 'ro', isa => 'Str', required   => 1 );
has 'sample_accession_number'    => ( is => 'ro', isa => 'Maybe[Str]');
has 'taxon_id'                   => ( is => 'ro', isa => 'Int', required   => 1 );
has 'library_name'               => ( is => 'ro', isa => 'Str', required   => 1 );
has 'fragment_size'                => ( is => 'ro', isa => 'Maybe[Int]');
has 'raw_read_count'             => ( is => 'ro', isa => 'Maybe[Int]');
has 'raw_base_count'             => ( is => 'ro', isa => 'Maybe[Int]');
has 'comments'                   => ( is => 'ro', isa => 'Maybe[Str]');

# these get populated later if needed
has 'file_location_on_disk'      => ( is => 'rw', isa => 'Maybe[Str]');
has 'mate_file_location_on_disk' => ( is => 'rw', isa => 'Maybe[Str]');

has 'pipeline_filename'          => ( is => 'rw', isa => 'Str',       lazy_build => 1);
has 'pipeline_mate_filename'     => ( is => 'rw', isa => 'Maybe[Str]',lazy_build => 1);

# convert the filename found in the spreadsheet into a format that matches the pipeline schema
sub _build_pipeline_filename
{
  my ($self) = @_;
  $self->_convert_name_into_pipeline_format($self->filename, '_1.fastq.gz');
}

sub _build_pipeline_mate_filename
{
  my ($self) = @_;
  return undef unless(defined($self->mate_filename));
  $self->_convert_name_into_pipeline_format($self->filename, '_2.fastq.gz');
}

sub _convert_name_into_pipeline_format
{
  my ($self, $filename, $suffix) = @_;
  $filename =~ s!\.fastq\.gz$!!i;
  $filename =~ s!\.fq\.gz$!!i;
  $filename =~ s!\_1$!!i;
  return $filename.$suffix;
}

sub populate_file_locations_on_disk
{
  my ($self,$files_base_directory) = @_;
  
  if(defined($files_base_directory))
  {
    my $file_location_on_disk = UpdatePipeline::Spreadsheet::SequencingFiles->new(
      filename             => $self->filename,
      files_base_directory => $files_base_directory
    )->find_file_on_disk || UpdatePipeline::Exceptions::CantFindSequencingFile->throw(error => "Cant find file ".$self->filename." within directory ".$files_base_directory);
    $self->file_location_on_disk($file_location_on_disk);
    
    if(defined($self->mate_filename))
    {
      my $mate_file_location_on_disk = UpdatePipeline::Spreadsheet::SequencingFiles->new(
        filename             => $self->mate_filename,
        files_base_directory => $files_base_directory
      )->find_file_on_disk || UpdatePipeline::Exceptions::CantFindSequencingFile->throw(error => "Cant find file ".$self->mate_filename." within directory ".$files_base_directory);
      $self->mate_file_location_on_disk($mate_file_location_on_disk);
    }
  }
  
  return $self;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

