package Warehouse::LibraryAliquots;

# ABSTRACT: Take in the name of a study and lookup metadata from the aliquots table.

=head1 SYNOPSIS

Take in the name of a study and lookup metadata from the aliquots table, study, sample, library
   use Warehouse::LibraryAliquots;
   
   my $plot_groups_obj = Warehouse::LibraryAliquots->new(
       study_name        => 'ABC',
     );
   $plot_groups_obj->libraries_metadata();

=cut

use Moose;
use UpdatePipeline::LibraryMetaData;

has 'study_name'         => ( is => 'ro', isa => 'Str', required => 1 );
has '_dbh'               => ( is => 'rw', required => 1 );
has 'libraries_metadata' => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_libraries_metadata' );
has 'receptacle_type'    => ( is => 'rw', isa => 'Str', default => 'pac_bio_library_tube' );

sub _construct_query {
    my ($self) = @_;

    return
'select sample.name,  sample.supplier_name from current_studies as study 
  left join current_aliquots as aliquots on aliquots.study_internal_id = study.internal_id
  left join current_samples as sample on sample.internal_id = aliquots.sample_internal_id
  where study.name like "'
      . $self->study_name . '"  and aliquots.receptacle_type like "' . $self->receptacle_type . '" and sample.common_name is not NULL';
}

sub _build_libraries_metadata {
    my ($self) = @_;
    my @libraries_metadata;
    my $library_aliquots = $self->_dbh->selectall_arrayref( $self->_construct_query );

    for my $library_aliquot (@$library_aliquots) {
        my $library_metadata_container = UpdatePipeline::LibraryMetaData->new(
            study_name              => $self->study_name,
            sample_name             => @$library_aliquot[0],
            supplier_name           => @$library_aliquot[1],
        );
        push( @libraries_metadata, $library_metadata_container );
    }
    return \@libraries_metadata;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
