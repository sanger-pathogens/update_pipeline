=head1 NAME

Individual.pm   - Link between the input meta data for a sample and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Individual;
my $sample = UpdatePipeline::VRTrack::Individual->new(
  name         => 'My name',
  _vrtrack     => $vrtrack_dbh,
  _vr_project  => $_vrproject
  );

my $vr_sample = $sample->vr_sample();

=cut


package UpdatePipeline::VRTrack::Individual;
use VRTrack::Individual;
use Moose;

has 'name'           => ( is => 'rw', isa => 'Str', required   => 1 );
has 'common_name'    => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vrtrack'       => ( is => 'rw',               required   => 1 );
has '_vrproject'     => ( is => 'rw',               required   => 1 );

has 'vr_individual'  => ( is => 'rw',               lazy_build => 1 );


sub _build_vr_individual
{
  my($self) = @_;
  my $individual = VRTrack::Individual->new_by_name( $self->_vrtrack, $self->name );
  if ( not defined $individual ) {
    $individual = VRTrack::Individual->create( $self->_vrtrack, $self->name);
    $individual->species($self->common_name);
  }
  return $individual;
}

1;