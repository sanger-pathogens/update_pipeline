=head1 NAME

Sample.pm   - Link between the input meta data for a sample and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Sample;
my $sample = UpdatePipeline::VRTrack::Sample->new(
  name         => 'My name',
  common_name  => 'SomeBacteria',
  _vrtrack     => $vrtrack_dbh,
  _vr_project  => $_vrproject
  );

my $vr_sample = $sample->vr_sample();

=cut


package UpdatePipeline::VRTrack::Sample;
use VRTrack::Sample;
use Moose;

has 'name'        => ( is => 'rw', isa => 'Str', required   => 1 );
has 'common_name' => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'    => ( is => 'rw',               required   => 1 );
has '_vr_project' => ( is => 'rw',               required   => 1 );

has 'vr_sample'   => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_sample
{
  my ($self) = @_;
  my $vsample = VRTrack::Sample->new_by_name_project( $self->_vrtrack, $self->name, $self->_vr_project->id );
  unless(defined($vsample))
  {
    $vsample = $self->_vr_project->add_sample($self->name);
  }
  
  # an individual links a sample to a species
  my $vr_individual = VRTrack::Individual->new_by_name( $self->_vrtrack, $self->name );
  if ( not defined $vr_individual ) {
    $vr_individual = $vsample->add_individual($self->name);
    $vsample->update;
  }
  if(not defined $vr_individual->species)
  {
    $vr_individual->add_species($self->common_name);
    $vr_individual->update;
  }
  
  return $vsample;
}


1;