package UpdatePipeline::PB::FileMetaData;
# ABSTRACT: Container for the metadata on a file

=head1 SYNOPSIS

Container for the metadata on a file
   use UpdatePipeline::PB::FileMetaData;
   
   my $obj = UpdatePipeline::PB::FileMetaData->new(

     );

=cut

use Moose;
use UpdatePipeline::Exceptions;
                                
has 'study_name'                       => ( is => 'rw', isa => 'Maybe[Str]');
has 'study_accession_number'           => ( is => 'rw', isa => 'Maybe[Str]');
has 'library_name'                     => ( is => 'rw', isa => 'Maybe[Str]');
has 'library_ssid'                     => ( is => 'rw', isa => 'Maybe[Str]');
has 'sample_name'                      => ( is => 'rw', isa => 'Maybe[Str]');
has 'sample_accession_number'          => ( is => 'rw', isa => 'Maybe[Str]');
has 'sample_common_name'               => ( is => 'rw', isa => 'Maybe[Str]');
has 'supplier_name'                    => ( is => 'rw', isa => 'Maybe[Str]');
has 'study_ssid'                       => ( is => 'rw', isa => 'Maybe[Int]');
has 'sample_ssid'                      => ( is => 'rw', isa => 'Maybe[Int]');
has 'lane_name'                        => ( is => 'rw', isa => 'Maybe[Str]');
has 'md5'                              => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_location'                    => ( is => 'rw', isa => 'Maybe[Str]');



__PACKAGE__->meta->make_immutable;

no Moose;

1;
