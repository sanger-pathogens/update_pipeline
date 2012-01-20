sub get_lane
{
  my ($id_run, $lane, $tag_index, $total_reads, $vlibrary, $vrtrack) = @_;
  
  my $lane_name = $id_run.'_'.$lane;
  if(defined($tag_index))
  {
    $lane_name = $id_run.'_'.$lane.'#'.$tag_index;
  }
  
  my $vlane = VRTrack::Lane->new_by_name( $vrtrack, $lane_name);
  unless(defined($vlane))
  {
    $vlane = $vlibrary->add_lane($lane_name);
  }
  
  $vlane->raw_reads( $total_reads );
  $vlane->hierarchy_name( $lane_name );
  $vlane->update;
  
  return $vlane;
}