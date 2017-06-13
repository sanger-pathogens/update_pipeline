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
extends 'UpdatePipeline::CommonFileMetaData';
                                
has 'md5'                              => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_location'                    => ( is => 'rw', isa => 'Maybe[Str]');
has 'lane_name'                        => ( is => 'rw', isa => 'Maybe[Str]');


__PACKAGE__->meta->make_immutable;

no Moose;

1;
