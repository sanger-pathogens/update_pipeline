=head1 NAME

UpdatePipeline::Validate.pm   - Take in a list of study names, and a VRTracking database handle and produce a report on the current state of the data in the pipeline compared to IRODS

=head1 SYNOPSIS

my $validate_pipeline = UpdatePipeline::Validate->new(study_names => \@study_names, _vrtrack => $vrtrack);
$validate_pipeline->report();

=cut
package UpdatePipeline::Validate;
use Moose;
use UpdatePipeline::IRODS;
use UpdatePipeline::VRTrack::LaneMetaData;

has 'study_names'  => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'     => ( is => 'rw', required => 1 );

has '_files_metadata'  => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );
has '_lanes_metadata'  => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

has 'report'  => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

sub _build__files_metadata
{
  my ($self) = @_;
  my $irods_files_metadata = UpdatePipeline::IRODS->new(
    study_names => $self->study_names
    )->files_metadata();
  return \$irods_files_metadata;
}

sub _build__lanes_metadata
{
  my ($self) = @_;
  my %lanes_metadata;
  for my $file_metadata (@{self->_files_metadata})
  {
    $lanes_metadata{$file_metadata->file_name_without_extension} = UpdatePipeline::VRTrack::LaneMetaData->new(
      name => $file_metadata->file_name_without_extension, 
      _vrtrack => $self->vrtrack
    )->lane_attributes();
  }
  return \%lanes_metadata;
}


sub _build_report
{
  my ($self) = @_;
  my %report;
  
  $report{files_missing_from_tracking} = 0;
  $report{total_files_in_irods} = 0;
  $report{num_inconsistent} = 0;
  
  for my $file_metadata (@{$self->_files_metadata})
  {
    
    if($self->_lanes_metadata->{$file_metadata->file_name_without_extension})
    {
      if($self->_compare_file_metadata_with_vrtrack_lane_metadata($file_metadata, $self->_lanes_metadata->{$file_metadata->file_name_without_extension} ) )
      {
        #everything okay
      }
      else
      {
        #inconsitent data
        $report{num_inconsistent}++;
      }
      
    }
    else
    {
      # file missing from tracking database
      $report{files_missing_from_tracking}++;
    }
    $report{total_files_in_irods}++;
  }
  
  return \%report;
}

sub _compare_file_metadata_with_vrtrack_lane_metadata
{
  my ($self, $file_metadata, $lane_metadata) = @_;
  
  if( $file_metadata->sample_name  eq $lane_metadata->{sample_name}  &&
      $file_metadata->study_name   eq $lane_metadata->{study_name}   &&
      $file_metadata->library_name eq $lane_metadata->{library_name} &&
      $file_metadata->library_ssid eq $lane_metadata->{library_ssid} &&
      $file_metadata->total_reads  eq $lane_metadata->{total_reads} )
  {
   return 1; 
  }
  return 0;
}

1;



