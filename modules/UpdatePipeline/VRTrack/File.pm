sub get_file
{
  my ($vlane, $md5, $vrtrack) = @_;
  # TODO make sure you dont repeatedly download bam files
  my $vfile;
  return $vfile if ($vlane->is_processed( 'import'));

  $vfile = $vlane->get_file_by_name($vlane->name.'.bam');
  unless(defined($vfile))
  {
    $vfile = $vlane->add_file($vlane->name.'.bam');
    $vfile->md5($md5);
    $vfile->type(4);
    $vfile->update;
  }
  return $vfile;
}