=head1 NAME

Project.pm   - Link between the input meta data for a project and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Project;
my $project = UpdatePipeline::VRTrack::Project->new(
  name => 'My name',
  _vrtrack => $vrtrack_dbh
  );

my $vr_project = $project->vr_project();

=cut


package UpdatePipeline::VRTrack::Project;
use VRTrack::Project;
use Moose;

has 'name'       => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'   => ( is => 'rw', required   => 1 );
has 'vr_project' => ( is => 'rw', lazy_build => 1 );

sub _build_vr_project
{
  my ($self) = @_;
  
  my $vproject = VRTrack::Project->new_by_name( $self->_vrtrack, $self->name );
  
  unless(defined($vproject))
  {
    $vproject = $vrtrack->add_project($self->name);
  }
  return $vproject;
}


1;