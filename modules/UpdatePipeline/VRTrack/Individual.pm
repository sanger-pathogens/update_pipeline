# we dont use individuals so this is the same as the sample and is a way to link to the species
sub get_individual
{
  my ($sample_name, $vrtrack) = @_;
  my $individual = VRTrack::Individual->new_by_name( $vrtrack, $sample_name );

  my $organism  = get_common_name_from_sample_name($sample_name, $vrtrack);

  if ( not defined $individual ) {
    $individual = VRTrack::Individual->create( $vrtrack, $sample_name);
    $individual->species($organism);
  }
  
}