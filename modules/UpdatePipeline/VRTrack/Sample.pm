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
use UpdatePipeline::Exceptions;
use Moose;

has 'name'        => ( is => 'ro', isa => 'Str', required   => 1 );
has 'common_name' => ( is => 'ro', isa => 'Str', required   => 1 );
has '_vrtrack'    => ( is => 'ro',               required   => 1 );
has '_vr_project' => ( is => 'ro',               required   => 1 );

has 'accession'   => ( is => 'ro', isa => 'Maybe[Str]' );
has 'external_id' => ( is => 'ro', isa => 'Maybe[Int]' );

# external variable
has 'vr_sample'   => ( is => 'ro',               lazy_build => 1 );
#internal variable
has '_vr_species' => ( is => 'ro',               lazy_build => 1 );

sub _build_vr_sample
{
  my ($self) = @_;
  # trigger the species to be checked against the common name before building the sample
  $self->_vr_species();
  
  my $vsample = VRTrack::Sample->new_by_name_project( $self->_vrtrack, $self->name, $self->_vr_project->id );
  unless(defined($vsample))
  {
    $vsample = $self->_vr_project->add_sample($self->name);
  }
  UpdatePipeline::Exceptions::CouldntCreateSample->throw( error => "Couldnt create sample with name ".$self->name."\n" ) if(not defined($vsample));
  
  
  
  # an individual links a sample to a species
  my $vr_individual = VRTrack::Individual->new_by_name( $self->_vrtrack, $self->name );
  if ( not defined $vr_individual ) {
    $vr_individual = $vsample->add_individual($self->name);
  }
  elsif(not defined ($vsample->individual) ||  (defined ($vsample->individual) && $vr_individual->id() != $vsample->individual_id() ))  
  {
    $vsample->individual_id($vr_individual->id);
  }
  $vsample->ssid($self->external_id);
  $vsample->update;
  
  # if there is no species defined, only attach one thats already defined, dont create one.
  if(not defined $vr_individual->species)
  {
    $vr_individual->species_id($self->_vr_species->id);
    $vr_individual->update;
  }
  
  if ( defined($vr_individual) && defined($self->accession)) 
  {
    $vr_individual->acc($self->accession);
    $vr_individual->update();
  }
  
  return $vsample;
}

# the species exists or throw an error and stop adding the sample
sub _build__vr_species
{
  my ($self) = @_;
  my $vr_species = VRTrack::Species->new_by_name( $self->_vrtrack, $self->common_name) || UpdatePipeline::Exceptions::UnknownCommonName->throw( error => $self->common_name );
  return $vr_species;
}


1;