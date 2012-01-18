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
use UpdatePipeline::FileMetaData;
extends 'UpdatePipeline::CommonSettings';

has 'study_names'      => ( is => 'rw', isa => 'ArrayRef[Str]', required   => 1 );
has 'files_metadata'   => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );

has '_irods_studies'   => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );
has '_warehouse_dbh'   => ( is => 'rw', lazy_build => 1 );


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
          )->file_metadata;
    
    my %file_metadata = UpdatePipeline::FileMetaData->new(
    );
    # get data from warehouse
    # build UpdatePipeline::FileMetaData objects for each
    push(@files_metadata, \%file_metadata);
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


1;
