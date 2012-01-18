=head1 NAME

FileMetaData.pm   - Represents a container of metadata about a file

=head1 SYNOPSIS

use UpdatePipeline::File;
my $file = UpdatePipeline::File->new(
  file_location => '/seq/1234/1234_5.bam'
  );

my %file_metadata = $file->file_metadata();

=cut
package UpdatePipeline::FileMetaData;
use Moose;
1;