sub get_sample
{
  my ($sample_name, $vproject,$vrtrack) = @_;
  my $vsample = VRTrack::Sample->new_by_name_project( $vrtrack, $sample_name, $vproject->id );
  unless(defined($vsample))
  {
    $vsample = $vproject->add_sample($sample_name);
  }
  
  get_individual($sample_name, $vrtrack);
  
  return $vsample;
}
