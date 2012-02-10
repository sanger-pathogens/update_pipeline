=head1 NAME

Sample.pm   - Link between the input meta data for a sample and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Sample;
my $sample = UpdatePipeline::VRTrack::Sample->new(
  name         => 'My name',
  _vrtrack     => $vrtrack_dbh,
  _vr_project  => $_vrproject
  );

my $vr_sample = $sample->vr_sample();

=cut


package UpdatePipeline::VRTrack::Sample;
use VRTrack::Sample;
use UpdatePipeline::VRTrack::Individual;
use Moose;

has 'name'        => ( is => 'rw', isa => 'Str', required   => 1 );
has 'common_name' => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'    => ( is => 'rw',               required   => 1 );
has '_vrproject'  => ( is => 'rw',               required   => 1 );

has 'vr_sample'   => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_sample
{
  my ($self) = @_;
  my $vsample = VRTrack::Sample->new_by_name_project( $self->_vrtrack, $self->name, $self->_vrproject->id );
  unless(defined($vsample))
  {
    $vsample = $self->_vrproject->add_sample($self->name);
  }
  
  UpdatePipeline::VRTrack::Individual->new(name => $self->name, _vrtrack => $self->_vrtrack, common_name => $self->common_name)->vr_individual;
  
  return $vsample;
}


1;