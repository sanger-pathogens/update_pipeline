=head1 NAME

Species.pm   - retrieve name for species from the database using taxon_id or get from NCBI 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Species;
my $species = UpdatePipeline::VRTrack::Species->new(
  taxon_id     => 9606,
  _vrtrack     => $vrtrack_dbh
  );

my $vr_species = $species->vr_species();

=cut


package UpdatePipeline::VRTrack::Species;
use VRTrack::Species;
use NCBI::TaxonLookup;

use Moose;

has 'taxon_id'    =>      ( is => 'rw', isa => 'Int', required   => 1 );
has '_vrtrack'    =>      ( is => 'rw',               required   => 1 );
has 'vr_species'  =>      ( is => 'rw',               lazy_build => 1 );

sub _build_vr_species
{
  my ($self) = @_;
  my $taxon_lookup = NCBI::TaxonLookup->new( taxon_id => $self->taxon_id );
  my $name = $taxon_lookup->common_name;
  my $vspecies = VRTrack::Species->new_by_name( $self->_vrtrack, $name);
  $vspecies = VRTrack::Species->create( $self->_vrtrack, $name, $self->taxon_id ) unless(defined($vspecies));
  UpdatePipeline::Exceptions::CouldntCreateSpecies->throw( error => "Couldnt create species with name ".$self->name."\n" ) if(not defined($vspecies));
  
  return $vspecies;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
