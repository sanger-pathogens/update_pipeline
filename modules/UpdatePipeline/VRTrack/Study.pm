# a study just contains an accession number in this case
sub get_study
{
  my ($study_accession,$vproject) = @_;

  my $vstudy = $vproject->study($study_accession);
  unless ($vstudy) {
    $vstudy = $vproject->add_study($study_accession);
  }
  return $vstudy;
}
