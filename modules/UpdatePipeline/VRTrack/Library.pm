=head1 NAME

Library.pm   - Link between the input meta data for a library and the VRTracking table of the same name. 

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::Library;
my $library = UpdatePipeline::VRTrack::Library->new(
  name         => 'My name',
  _vrtrack     => $vrtrack_dbh,
  _vr_sample  => $_vrsample
  );

my $vr_library = $library->vr_library();

=cut


package UpdatePipeline::VRTrack::Library;
use VRTrack::Library;
use Moose;

has 'name'                  => ( is => 'rw', isa => 'Str', required   => 1 );
has 'sequencing_technology' => ( is => 'rw', isa => 'Str', default    => "SLX" );
has '_vrtrack'              => ( is => 'rw',               required   => 1 );
has '_vr_sample'            => ( is => 'rw',               required   => 1 );

has 'vr_library'            => ( is => 'rw',               lazy_build => 1 );

sub _build_vr_library
{
  my ($self) = @_;
  my $vlibrary = VRTrack::Library->new_by_name( $self->_vrtrack, $self->name);
  unless(defined($vlibrary))
  {
    $vlibrary = $self->_vr_sample->add_library($self->name);
  }
  
  my $seq_tech = $vlibrary->seq_tech($self->sequencing_technology);
  unless ($seq_tech) {
        $vlibrary->add_seq_tech($self->sequencing_technology);
  }
  
  return $vlibrary;
}


1;