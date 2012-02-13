=head1 NAME

Lane.pm   - Link between the input meta data for a lane and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Lane;
my $sample = UpdatePipeline::VRTrack::Lane->new(
  name         => '1234_5#6',
  total_reads  => 1000,
  _vrtrack     => $vrtrack_dbh,
  _vr_library  => $_vr_library
  );

my $vr_lane = $sample->vr_lane();

=cut


package UpdatePipeline::VRTrack::Lane;
use VRTrack::Lane;
use Moose;

has 'name'        => ( is => 'rw', isa => 'Str', required   => 1 );
has 'total_reads' => ( is => 'rw', isa => 'Int', default    => 0 );
has '_vrtrack'    => ( is => 'rw',               required   => 1 );
has '_vr_library' => ( is => 'rw',               required   => 1 );

has 'vr_lane'   => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_lane
{
  my ($self) = @_;
  
  my $vlane = VRTrack::Lane->new_by_name( $self->_vrtrack, $self->name);
  unless(defined($vlane))
  {
    $vlane = $self->_vr_library->add_lane($self->name);
  }
  
  $vlane->raw_reads( $self->total_reads );
  $vlane->hierarchy_name( $self->name );
  $vlane->update;
  
  return $vlane;
}


1;