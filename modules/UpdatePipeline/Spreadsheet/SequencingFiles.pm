=head1 NAME

SequencingFiles.pm   - Take in a sequencing file and a base directory and find where it is located on disk

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::SequencingFiles;
UpdatePipeline::Spreadsheet::SequencingFiles->new(
  filename             => 'myfile.gz',
  files_base_directory => '/path/to/directory'
)->find_file_on_disk;


=cut

package UpdatePipeline::Spreadsheet::SequencingFiles;
use Moose;
use Moose::Util::TypeConstraints;
use File::Find::Rule;


subtype 'Directory'
     => as 'Str'
     => where { (-d $_) }
     => message { "$_  directory doesnt exist" };

has 'files_base_directory' => ( is => 'ro', isa => 'Directory',  required => 1 );
has 'filename'             => ( is => 'ro', isa => 'Str',        required => 1 );

has '_file_location'       => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1 );

sub _build__file_location
{
  my ($self) = @_;
  my @files = File::Find::Rule->file()
                                ->name( $self->filename )
                                ->in($self->files_base_directory );
  return $files[0] if(@files > 0);
  return undef;
}

sub find_file_on_disk
{
  my ($self) = @_;
  $self->_file_location;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
