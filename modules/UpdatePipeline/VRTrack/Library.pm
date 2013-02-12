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
has 'fragment_size_from'    => ( is => 'rw', isa => 'Maybe[Int]' );
has 'fragment_size_to'      => ( is => 'rw', isa => 'Maybe[Int]' );

has '_vrtrack'              => ( is => 'ro',               required   => 1 );
has '_vr_sample'            => ( is => 'ro',               required   => 1 );

has 'vr_library'            => ( is => 'ro',               lazy_build => 1 );

sub _build_vr_library
{
  my ($self) = @_;
  my $vlibrary = VRTrack::Library->new_by_name( $self->_vrtrack, $self->name);
  unless(defined($vlibrary))
  {
    eval{
      $vlibrary = $self->_vr_sample->add_library($self->name);
    };
    if($@)
    {
       UpdatePipeline::Exceptions::DuplicateLibraryName->throw( error => $self->name );
    }
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
  $self->add_fragment_sizes_if_not_previously_set($vlibrary);
  
  unless ($vlibrary->seq_tech($self->sequencing_technology)) { $vlibrary->add_seq_tech($self->sequencing_technology); }
  unless ($vlibrary->seq_centre($self->sequencing_centre))   { $vlibrary->add_seq_centre($self->sequencing_centre); }
  $vlibrary->update;
  return $vlibrary;
}

sub add_fragment_sizes_if_not_previously_set
{
  my ($self,$vlibrary) = @_;
  return unless(defined($self->fragment_size_from) && defined($self->fragment_size_to));
  $self->swap_fragment_sizes_if_to_less_than_from();

  return if(defined($vlibrary->fragment_size_from) && defined($vlibrary->fragment_size_to));
  $vlibrary->fragment_size_from($self->fragment_size_from);
  $vlibrary->fragment_size_to($self->fragment_size_to);
}

sub swap_fragment_sizes_if_to_less_than_from
{
   my ($self) = @_;
   if($self->fragment_size_from > $self->fragment_size_to)
   {
     my $swap_fragement_value = $self->fragment_size_from;
     $self->fragment_size_from($self->fragment_size_to);
     $self->fragment_size_to($swap_fragement_value);
   }
   
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
