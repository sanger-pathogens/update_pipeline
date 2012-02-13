=head1 NAME

File.pm   - Link between the input meta data for a file and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::File;
my $file = UpdatePipeline::VRTrack::File->new(
  name         => 'myfile.bam',
  md5          => 'abc1231343432432432',
  _vrtrack     => $vrtrack_dbh,
  _vr_lane     => $_vr_lane
  );

my $vr_file = $file->vr_file();

=cut


package UpdatePipeline::VRTrack::File;
use VRTrack::File;
use Moose;

has 'name'        => ( is => 'rw', isa => 'Str', required   => 1 );
has 'md5'         => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'    => ( is => 'rw',               required   => 1 );
has '_vr_lane'    => ( is => 'rw',               required   => 1 );
has 'file_type'   => ( is => 'rw', isa => 'Int', default    => 4 );

has 'vr_file'     => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_file
{
  my ($self) = @_;

  my $vfile;
  return $vfile if ($self->_vr_lane->is_processed( 'import'));

  $vfile = $self->_vr_lane->get_file_by_name($self->name);
  unless(defined($vfile))
  {
    $vfile = $self->_vr_lane->add_file($self->name);
    $vfile->md5($self->md5);
    $vfile->type($self->file_type);
    $vfile->update;
  }
  return $vfile;
}

1;
