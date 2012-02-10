=head1 NAME

Study.pm   - Link between the input meta data for a study and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Study;
my $study = UpdatePipeline::VRTrack::Study->new(
  name => 'My name',
  _vrtrack => $vrtrack_dbh
  );

my $vr_study = $project->vr_study();

=cut


package UpdatePipeline::VRTrack::Study;
use VRTrack::Study;
use Moose;

has 'accession'  => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vproject'  => ( is => 'rw',               required   => 1 );
has 'vr_study'   => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_study
{
  my ($self) = @_;

  my $vstudy = $self->vproject->study($self->accession);
  unless ($vstudy) {
    $vstudy = $self->vproject->add_study($self->accession);
  }
  return $vstudy;
}

1;