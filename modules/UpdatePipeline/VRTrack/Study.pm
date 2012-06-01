=head1 NAME

Study.pm   - Link between the input meta data for a study and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Study;
my $study = UpdatePipeline::VRTrack::Study->new(
  accession => 'My accession',
  _vr_project => $_vr_project
  );

my $vr_study = $project->vr_study();

=cut


package UpdatePipeline::VRTrack::Study;
use VRTrack::Study;
use Moose;

has 'accession'   => ( is => 'rw', isa => 'Str', required   => 1 );
has '_vr_project' => ( is => 'rw',               required   => 1 );
has 'vr_study'    => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_study
{
  my ($self) = @_;

  my $vstudy = $self->_vr_project->study($self->accession);
  unless ($vstudy) {
    $vstudy = $self->_vr_project->add_study($self->accession);
  }
  UpdatePipeline::Exceptions::CouldntCreateStudy->throw( error => "Couldnt create study with name ".$self->name."\n" ) if(not defined($vstudy));  
  
  return $vstudy;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
