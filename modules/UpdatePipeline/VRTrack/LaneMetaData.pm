=head1 NAME

LaneMetaData.pm   - Given the name of a lane, look up the tracking database and return all the metadata about it in a denormalised format.

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::LaneMetaData;
my $lane_metadata= UpdatePipeline::VRTrack::LaneMetaData->new(
  name => '1234_5#6',
  _vrtrack => $vrtrack
  );

my %lane_metadata = $lane_metadata->lane_attributes();

=cut

package UpdatePipeline::VRTrack::LaneMetaData;
use UpdatePipeline::Common;
use Moose;

has 'name'       => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'   => ( is => 'rw', required   => 1 );
has 'lane_attributes'   => ( is => 'rw', lazy_build   => 1 );


sub _build_lane_attributes
{
  my ($self) = @_; 
  my $search_query = $self->name;
  my $sql = qq[select 
  study.acc as study_accession_number, 
  sample.name as sample_name,  
  project.name as study_name,
  library.name as library_name,
  library.ssid as library_ssid,
  lane.raw_reads as total_reads,
  ifnull(individual.acc,'NO_ACC') as sample_accession_number,
  species.name as sample_common_name,
  lane.npg_qc_status as lane_manual_qc,
  lane.paired as lane_is_paired_read,
  lane.changed as lane_changed,
  lane.name as lane_name,
  timestampdiff( hour, lane.changed, now() ) as hours_since_lane_changed,
  sample.ssid as sample_ssid,
  project.ssid as study_ssid,
  lane.processed as lane_processed,
  library.fragment_size_from as fragment_size_from,
  library.fragment_size_to as fragment_size_to,
  file.md5 as file_md5
  from latest_lane as lane
  left join latest_file as file on file.lane_id = lane.lane_id
  left join latest_library as library on library.library_id = lane.library_id 
  left join latest_sample as sample on sample.sample_id = library.sample_id
  left join latest_project as project on project.project_id = sample.project_id
  left join study as study on project.study_id = study.study_id
  left join individual as individual on individual.individual_id = sample.individual_id
  left join species as species on species.species_id = individual.species_id
  where lane.name = "$search_query" and file.md5 is not null limit 1];

  my $sth = $self->_vrtrack->{_dbh}->prepare($sql);

  my %lane_attributes;
  my $tmp_return_value;
  if ($sth->execute()){
    $tmp_return_value = $sth->fetchrow_hashref;
    if($tmp_return_value)
    {
     %lane_attributes = %{$tmp_return_value};
    }
  }
  else{
      die(sprintf('Cannot retrieve tracking data: %s', $DBI::errstr));
  }
  
  # check to see if there are any values in the returned hash
  return undef unless(UpdatePipeline::Common::array_contains_value(values(%lane_attributes)));
  
  return \%lane_attributes;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
