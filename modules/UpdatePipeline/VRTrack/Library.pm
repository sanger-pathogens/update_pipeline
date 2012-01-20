sub get_library
{
  my ($library_name, $library_id, $vsample, $vrtrack) = @_;
  my $vlibrary = VRTrack::Library->new_by_name( $vrtrack, $library_name);
  unless(defined($vlibrary))
  {
    $vlibrary = $vsample->add_library($library_name);
  }
  
  my $seq_tech = $vlibrary->seq_tech('SLX');
  unless ($seq_tech) {
        $vlibrary->add_seq_tech('SLX');
  }
  
  return $vlibrary;
}