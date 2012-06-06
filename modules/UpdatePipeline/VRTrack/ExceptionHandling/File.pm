=head1 NAME

File.pm   - Fix a file when there is an exception. Just sets latest = 0 for a given name

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::ExceptionHandling::File;
my $file_exception_handler = UpdatePipeline::VRTrack::ExceptionHandling::File->new(
  name         => '1234_5#6',
  _vrtrack     => $vrtrack_dbh,
  );
$file_exception_handler->delete_files();

=cut


package UpdatePipeline::VRTrack::ExceptionHandling::File;
use VRTrack::File;
use Moose;

has 'name'      => ( is => 'rw', isa => 'Str',  required   => 1 );
has '_vrtrack'  => ( is => 'rw', required => 1 );

sub delete_files
{
  my($self)= @_;
  my $search_query = $self->name;  

  my $file_sql = qq[update latest_file set latest = 0 where 
  name in  ("${search_query}_1.fastq.gz", "${search_query}_2.fastq.gz", "${search_query}.bam") OR
  hierarchy_name in ("${search_query}_1.fastq.gz", "${search_query}_2.fastq.gz", "${search_query}.bam") limit 3];
  $self->_vrtrack->{_dbh}->do($file_sql);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
