=head1 NAME

IRODS.pm   - Take in a set of Studies, lookup all files in IRODS,  Create FileMetaData for each, populate the metadata from IRODS and the Warehouse.

=head1 SYNOPSIS

use UpdatePipeline::IRODS;
my $update_pipeline_irods = UpdatePipeline::IRODS->new(
  study_names => ['StudyA', 'StudyB'],
  environment => 'test',
  );

my @files_metadata = $update_pipeline_irods->files_metadata();

=cut

package UpdatePipeline::IRODS;
use Moose;
use IRODS::Study;
use IRODS::File;
use Warehouse::File;
use Warehouse::Database;
use UpdatePipeline::FileMetaData;
extends 'UpdatePipeline::CommonSettings';

has 'study_names'      => ( is => 'rw', isa => 'ArrayRef[Str]', required   => 1 );
has 'files_metadata'   => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );

has '_irods_studies'   => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );
has '_warehouse_dbh'   => ( is => 'rw', lazy_build => 1 );

sub _build__warehouse_dbh
{
  my ($self) = @_;
  Warehouse::Database->new(settings => $self->_database_settings->{warehouse})->connect;
}

sub _build__irods_studies
{
  my ($self) = @_;
  my @irods_studies;
  
  for my $study_name (@{$self->study_names})
  {
     push(@irods_studies, IRODS::Study->new(name => $study_name));
  }
   
  return \@irods_studies;
}

sub _build_files_metadata
{
  my ($self) = @_;
  my @files_metadata;
  
  my @irods_files_metadata = @{$self->_get_irods_file_metadata_for_studies()};

  for my $irods_file_metadata (@irods_files_metadata)
  {
    my $warehouse_file = Warehouse::File->new(
      input_metadata => $irods_file_metadata,
      _dbh => $self->_warehouse_dbh
          )->file_attributes;
    
    my $file_metadata = UpdatePipeline::FileMetaData->new(
      study_name              => $irods_file_metadata->{study},
      study_accession_number  => $irods_file_metadata->{study_accession_number},
      file_md5                => $irods_file_metadata->{md5},
      file_type               => $irods_file_metadata->{type},
      file_name               => $irods_file_metadata->{file_name},
      file_name_without_extension => $irods_file_metadata->{file_name_without_extension},
      library_name            => $irods_file_metadata->{library},
      library_ssid            => $irods_file_metadata->{library_id},
      total_reads             => $irods_file_metadata->{total_reads},
      sample_name             => $irods_file_metadata->{sample},
      sample_accession_number => $irods_file_metadata->{sample_accession_number},
      lane_is_paired_read     => $irods_file_metadata->{is_paired_read},
      lane_manual_qc          => $irods_file_metadata->{manual_qc},
      sample_common_name      => $irods_file_metadata->{sample_common_name},
    );
    # get data from warehouse
    push(@files_metadata, $file_metadata);
  }
  
  return \@files_metadata;
}

sub _get_irods_file_metadata_for_studies
{
  my ($self) = @_;
  my @files_metadata;
  
  for my $irods_study (@{$self->_irods_studies})
  {
    for my $file_metadata (@{$irods_study->file_locations()})
    {
      push(@files_metadata, IRODS::File->new(file_location => $file_metadata)->file_attributes );
    }
  }
  
  return \@files_metadata;
}

sub print_file_metadata
{
  my ($self) = @_;
  
  for my $file_metadata (@{$self->files_metadata})
  {
    print( ($file_metadata->study_name              ? $file_metadata->study_name              : '')  .', ');
    print( ($file_metadata->study_accession_number  ? $file_metadata->study_accession_number  : '')  .', ');
    print( ($file_metadata->file_md5                ? $file_metadata->file_md5                : '')  .', ');
    print( ($file_metadata->file_type               ? $file_metadata->file_type               : '')  .', ');
    print( ($file_metadata->file_name               ? $file_metadata->file_name               : '')  .', ');
    print( ($file_metadata->library_name            ? $file_metadata->library_name            : '')  .', ');
    print( ($file_metadata->library_ssid            ? $file_metadata->library_ssid            : '')  .', ');
    print( ($file_metadata->total_reads             ? $file_metadata->total_reads             : '')  .', ');
    print( ($file_metadata->sample_name             ? $file_metadata->sample_name             : '')  .', ');
    print( ($file_metadata->sample_accession_number ? $file_metadata->sample_accession_number : '')  ."\n");
  }
}


1;
