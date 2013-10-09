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

has 'name'         => ( is => 'rw', isa => 'Str', required   => 1 );
has 'md5'          => ( is => 'rw', isa => 'Maybe[Str]');
has '_vrtrack'     => ( is => 'rw',               required   => 1 );
has '_vr_lane'     => ( is => 'rw',               required   => 1 );
has 'file_type'    => ( is => 'rw', isa => 'Int', default    => 4 );
has 'override_md5' => ( is => 'ro', isa => 'Bool', default   => 0 );

has 'vr_file'      => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_file
{
  my ($self) = @_;

  my $vfile;
  
  return $vfile if ($self->_vr_lane->is_processed('import') && !$self->override_md5);
  
  $vfile = $self->_vr_lane->get_file_by_name($self->name); 
  unless(defined($vfile))
  {
    # see if the file exists but with a different lane_id
    my $existing_vfile  = VRTrack::File->new_by_name( $self->_vrtrack, $self->name);
    if(defined($existing_vfile))
    {
      $vfile = $existing_vfile;
      $vfile->lane_id($self->_vr_lane->id);
    }
    else
    {
      $vfile = $self->_vr_lane->add_file($self->name);
    }
  }
  UpdatePipeline::Exceptions::CouldntCreateFile->throw( error => "Couldnt create file with name ".$self->name."\n" ) if(not defined($vfile));
  
  if(defined($self->md5))
  {
    if(defined($vfile->md5) && $vfile->md5 ne "")
    {
      if ($self->override_md5) {
		$vfile->md5($self->md5);
	  } 
	  else {
		  UpdatePipeline::Exceptions::FileMD5Changed->throw( error => "File ".$self->name." MD5 changed from ".$vfile->md5." to ".$self->md5." so need to reimport\n" ) if($self->md5 ne $vfile->md5);
	  }	  
    }
    else
    {
       $vfile->md5($self->md5);
    }
  }
  
  $vfile->type($self->file_type);
  $vfile->update;
  
  return $vfile;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
