package UpdatePipeline::LibraryMetaData;

# ABSTRACT: Represents a container of metadata about a library from the aliquots warehouse lookup.

=head1 SYNOPSIS

Represents a container of metadata about a library from the aliquots warehouse lookup. 

   use UpdatePipeline::LibraryMetaData;
   my $library_metadata_container = UpdatePipeline::LibraryMetaData->new(
     study_name => 'My Study'
     );

=cut

use Moose;

has 'study_name'              => ( is => 'rw', isa => 'Str' );
has 'study_accession_number'  => ( is => 'rw', isa => 'Maybe[Str]' );
has 'study_ssid'              => ( is => 'rw', isa => 'Maybe[Int]' );
has 'library_name'            => ( is => 'rw', isa => 'Maybe[Str]' );
has 'library_ssid'            => ( is => 'rw', isa => 'Maybe[Str]' );
has 'sample_ssid'             => ( is => 'rw', isa => 'Maybe[Int]' );
has 'sample_name'             => ( is => 'rw', isa => 'Maybe[Str]' );
has 'sample_accession_number' => ( is => 'rw', isa => 'Maybe[Str]' );
has 'sample_common_name'      => ( is => 'rw', isa => 'Maybe[Str]' );
has 'supplier_name'           => ( is => 'rw', isa => 'Maybe[Str]' );

__PACKAGE__->meta->make_immutable;

no Moose;

1;
