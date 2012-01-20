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

  my $sql = qq[select study.acc as study_accession_number, sample.name as sample_name,  
  project.name as study_name,
  library.name as library_name,
  library.ssid as library_ssid,
  lane.raw_reads as total_reads
  from latest_lane as lane
  left join latest_library as library on library.library_id = lane.library_id 
  left join latest_sample as sample on sample.sample_id = library.sample_id
  left join latest_project as project on project.project_id = sample.project_id
  left join study as study on project.study_id = study.study_id
  where lane.name = "$search_query" limit 1;];

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



1;
