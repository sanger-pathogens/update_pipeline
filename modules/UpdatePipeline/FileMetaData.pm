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
use UpdatePipeline::Exceptions;
                                
has 'study_name'                       => ( is => 'rw', isa => 'Maybe[Str]');
has 'study_accession_number'           => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_md5'                         => ( is => 'rw', isa => 'Maybe[Str]');
has 'file_type'                        => ( is => 'rw', isa => 'Str',         default    => 'bam' );
has 'file_name'                        => ( is => 'rw', isa => 'Str',         required   => 1 );
has 'file_name_without_extension'      => ( is => 'rw', isa => 'Str',         required   => 1 );
has 'mate_file_md5'                    => ( is => 'ro', isa => 'Maybe[Str]');
has 'mate_file_type'                   => ( is => 'ro', isa => 'Maybe[Str]');
has 'mate_file_name'                   => ( is => 'ro', isa => 'Maybe[Str]' );
has 'mate_file_name_without_extension' => ( is => 'ro', isa => 'Maybe[Str]');
has 'library_name'                     => ( is => 'rw', isa => 'Maybe[Str]');
has 'library_ssid'                     => ( is => 'rw', isa => 'Maybe[Str]');
has 'total_reads'                      => ( is => 'rw', isa => 'Maybe[Int]');
has 'sample_name'                      => ( is => 'rw', isa => 'Maybe[Str]');
has 'sample_accession_number'          => ( is => 'rw', isa => 'Maybe[Str]');
has 'sample_common_name'               => ( is => 'rw', isa => 'Maybe[Str]');
has 'supplier_name'                    => ( is => 'rw', isa => 'Maybe[Str]');
has 'lane_is_paired_read'              => ( is => 'rw', isa => 'Bool',        default    => 1 );
has 'lane_manual_qc'                   => ( is => 'rw', isa => 'Str',         default    => '-');
has 'study_ssid'                       => ( is => 'rw', isa => 'Maybe[Int]');
has 'sample_ssid'                      => ( is => 'rw', isa => 'Maybe[Int]');
has 'fragment_size_from'               => ( is => 'rw', isa => 'Maybe[Int]' );
has 'fragment_size_to'                 => ( is => 'rw', isa => 'Maybe[Int]' );
has 'id_run'                           => ( is => 'rw', isa => 'Maybe[Int]' ); 


sub file_type_number
{
  my($self,$file_type) = @_;
  if($file_type eq 'bam')
  {
   return 4; 
  }
  elsif($file_type eq 'fastq.gz')
  {
    return 1;
  }
  else
  {
    UpdatePipeline::Exceptions::UnknownFileType->throw(error => 'Unknown file type '+$file_type);
  }
  
  return -1;
}

sub mate_file_type_number
{
  my($self,$file_type) = @_;

  if($file_type eq 'fastq.gz')
  {
    return 2;
  }
  else
  {
    UpdatePipeline::Exceptions::UnknownFileType->throw(error => 'Unknown file type '+$file_type);
  }
  
  return -1;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
