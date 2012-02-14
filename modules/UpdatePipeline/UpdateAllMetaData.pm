=head1 NAME

UpdatePipeline::UpdateAllMetaData.pm   - Take in a list of study names, and a VRTracking database handle and update/create where IRODs differs to the tracking database

=head1 SYNOPSIS

my $pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => \@study_names, _vrtrack => $self->_vrtrack);
$pipeline->update();

=cut
package UpdatePipeline::UpdateAllMetaData;
use Moose;
use UpdatePipeline::IRODS;
use UpdatePipeline::VRTrack::LaneMetaData;
use UpdatePipeline::UpdateLaneMetaData;
extends 'UpdatePipeline::CommonMetaDataManipulation';

has 'study_names'         => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );

sub update
{
  my ($self) = @_;

  for my $file_metadata (@{$self->_files_metadata})
  {
    if(UpdatePipeline::UpdateLaneMetaData->new(
        lane_meta_data => $self->_lanes_metadata->{$file_metadata->file_name_without_extension},
        file_meta_data => $file_metadata)->update_required
      )
    {
        $self->_update_lane($file_metadata);
    }
  }
  return \%report;
}

sub _update_lane
{
  my ($self, $file_metadata) = @_;

  my $vproject = UpdatePipeline::VRTrack::Project->new(name => $file_metadata->study_name, _vrtrack => $self->_vrtrack)->vr_project();
  my $vstudy   = UpdatePipeline::VRTrack::Study->new(accession => $file_metadata->study_accession_number, _vr_project => $vproject)->vr_study();
  $vproject->update;
  my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => $file_metadata->sample_name, common_name => $file_metadata->sample_common_name, accession => $file_metadata->sample_accession_number, _vrtrack => $self->_vrtrack,_vr_project => $vproject)->vr_sample();
  my $vr_library = UpdatePipeline::VRTrack::Library->new(name => $file_metadata->library_name, external_id  => $file_metadata->library_ssid, _vrtrack => $self->_vrtrack,_vr_sample  => $vr_sample)->vr_library();

  my $vr_lane = UpdatePipeline::VRTrack::Lane->new(
    name          => $file_metadata->file_name_without_extension,
    total_reads   => $file_metadata->total_reads,
    paired        => $file_metadata->lane_is_paired_read,
    npg_qc_status => $file_metadata->lane_manual_qc,
    _vrtrack      => $self->_vrtrack,
    _vr_library   => $vr_library)->vr_lane();

  my $vr_file = UpdatePipeline::VRTrack::File->new(name => $file_metadata->file_name ,md5 => $file_metadata->file_md5 ,_vrtrack => $self->_vrtrack,_vr_lane => $vr_lane)->vr_file();

}


1;

