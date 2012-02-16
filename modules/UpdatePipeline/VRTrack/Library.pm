=head1 NAME

Library.pm   - Link between the input meta data for a library and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Library;
my $library = UpdatePipeline::VRTrack::Library->new(
  name         => 'My name',
  external_id  => 123,
  _vrtrack     => $vrtrack_dbh,
  _vr_sample  => $_vrsample
  );

my $vr_library = $library->vr_library();

=cut


package UpdatePipeline::VRTrack::Library;
use VRTrack::Library;
use Moose;

has 'name'                  => ( is => 'ro', isa => 'Str', required   => 1 );
has 'external_id'           => ( is => 'ro', isa => 'Int' );

has 'sequencing_technology' => ( is => 'ro', isa => 'Str', default    => "SLX" );
has 'sequencing_centre'     => ( is => 'ro', isa => 'Str', default    => "SC" );
has '_vrtrack'              => ( is => 'ro',               required   => 1 );
has '_vr_sample'            => ( is => 'ro',               required   => 1 );

has 'vr_library'            => ( is => 'ro',               lazy_build => 1 );

sub _build_vr_library
{
  my ($self) = @_;
  my $vlibrary = VRTrack::Library->new_by_name( $self->_vrtrack, $self->name);
  unless(defined($vlibrary))
  {
    $vlibrary = $self->_vr_sample->add_library($self->name);
  }
  UpdatePipeline::Exceptions::CouldntCreateLibrary->throw( error => "Couldnt create library with name ".$self->name."\n" ) if(not defined($vlibrary));
  
  # check to see if the sample has been updated
  if($vlibrary->sample_id != $self->_vr_sample->id)
  {
    $vlibrary->sample_id($self->_vr_sample->id);
    $vlibrary->update();
  }
  
  if(defined $self->external_id)
  {
    $vlibrary->ssid($self->external_id);
    $vlibrary->update();
  }
  
  unless ($vlibrary->seq_tech($self->sequencing_technology)) { $vlibrary->add_seq_tech($self->sequencing_technology); }
  unless ($vlibrary->seq_centre($self->sequencing_centre))   { $vlibrary->add_seq_centre($self->sequencing_centre); }
  $vlibrary->update;
  return $vlibrary;
}

1;