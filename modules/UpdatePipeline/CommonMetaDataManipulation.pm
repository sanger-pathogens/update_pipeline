=head1 NAME

UpdatePipeline::CommonMetaDataManipulation.pm  - Common functionality for manipulating metadata used in the validator and in the updater

=cut

package UpdatePipeline::CommonMetaDataManipulation;
use Moose;


has '_files_metadata'           => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );
has '_lanes_metadata'           => ( is => 'rw', isa => 'HashRef',  lazy_build => 1 );
has 'number_of_files_to_return' => ( is => 'rw', isa => 'Maybe[Int]');
has 'study_names'               => ( is => 'rw', isa => 'ArrayRef', required   => 1 );

sub _build__files_metadata
{
  my ($self) = @_;
  my $irods_files_metadata = UpdatePipeline::IRODS->new(
    study_names               => $self->study_names,
    number_of_files_to_return => $self->number_of_files_to_return,
    _warehouse_dbh            => $self->_warehouse_dbh
    )->files_metadata();
  return $irods_files_metadata;
}

sub _build__lanes_metadata
{
  my ($self) = @_;
  my %lanes_metadata;
  for my $file_metadata (@{$self->_files_metadata})
  {
    $lanes_metadata{$file_metadata->file_name_without_extension} = UpdatePipeline::VRTrack::LaneMetaData->new(
      name => $file_metadata->file_name_without_extension, 
      _vrtrack => $self->_vrtrack
    )->lane_attributes();
  }
  return \%lanes_metadata;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
