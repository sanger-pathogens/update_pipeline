=head1 NAME

FileMetaData.pm   - Represents a container of metadata about a file. This is where validation on the input data is done.

=head1 SYNOPSIS

use UpdatePipeline::File;
my $file_meta_data_container = UpdatePipeline::FileMetaData->new(
  study_name => 'My Study'
  );

=cut
package UpdatePipeline::FileMetaData;
use Moose;
                                
has 'study_name'                 => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'study_accession_number'     => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_md5'                   => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_type'                  => ( is => 'rw', isa => 'Maybe[Str]',  default   => 'bam' );
has 'file_name'                  => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'file_name_without_extension' => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'library_name'               => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'library_ssid'               => ( is => 'rw', isa => 'Maybe[Str]');
has 'total_reads'                => ( is => 'rw', isa => 'Maybe[Int]');
has 'sample_name'                => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'sample_accession_number'    => ( is => 'rw', isa => 'Maybe[Str]');


1;