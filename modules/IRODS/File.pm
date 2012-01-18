=head1 NAME

File.pm   - Represents a single file with some metadata

=head1 SYNOPSIS

use IRODS::File;
my $file = IRODS::File->new(
  file_location => '/seq/1234/1234_5.bam'
  );

my %file_metadata = $file->file_metadata();

=cut

package IRODS::File;
use Moose;
extends 'IRODS::Common';

has 'file_location'                 => ( is => 'rw', isa => 'Str',  required   => 1 );
has 'file_attributes'               => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has 'file_containing_irods_output'  => ( is => 'rw', isa => 'Str'); # Used for testing, pass a file with output from IRODS

sub _build_file_attributes
{
   my ($self) = @_;
   my %file_attributes;
   my $irods_stream = $self->_stream_location() ;

   open( my $irods, $irods_stream ) or return  \%file_attributes;
   
   my $attribute = '';
   while (<$irods>) {
       if (/^attribute: (.+)$/) { $attribute                    = $1; }
       if (/^value: (.+)$/)     { $file_attributes{$attribute} = $1; }
   }
   close $irods;

   return \%file_attributes;
}

sub _stream_location
{
  my ($self) = @_; 
  
  if($self->file_containing_irods_output)
  {
    # Used for testing, pass a file with output from IRODS
    return $self->file_containing_irods_output;
  }
  
  return $self->bin_directory . "imeta ls -d ".$self->file_location." |";
}

1;