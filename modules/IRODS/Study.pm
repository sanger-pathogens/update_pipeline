=head1 NAME

Study.pm   - Represents the collection of files with a common study name in irods

=head1 SYNOPSIS

use IRODS::Study;
my $study = IRODS::Study->new(
  name => 'My Study'
  );

my @file_locations = $study->file_locations();

=cut

package IRODS::Study;
use Moose;
extends 'IRODS::Common';

has 'name'                          => ( is => 'rw', isa => 'Str', required   => 1 );
has 'file_containing_irods_output'  => ( is => 'rw', isa => 'Str'); # Used for testing, pass a file with output from IRODS
has 'file_locations'                => ( is => 'rw', isa => 'ArrayRef', lazy_build => 1 );

sub _build_file_locations
{
  my ($self) = @_; 
  my @file_location;
  my $irods_stream = $self->_stream_location() ;
  
  open( my $irods, $irods_stream ) or return  \@file_location;

  my  $attribute  = '';
  while (<$irods>) {
      my $data_obj;
      if (/^collection: (.+)$/) { $attribute = $1; }
      if (/^dataObj: (.+)$/)    { $data_obj  = $1; }
      if(defined ($data_obj))
      {
        push(@file_location, "$attribute/$data_obj");
      }
      
  }
  close $irods;

  return \@file_location;
}


sub _stream_location
{
  my ($self) = @_; 
  
  if($self->file_containing_irods_output)
  {
    # Used for testing, pass a file with output from IRODS
    return $self->file_containing_irods_output;
  }
  # and total_reads != 0

  return $self->bin_directory . "imeta qu -z seq -d study = '".$self->name."' and target = 1 and total_reads != 0 |";
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
