package IRODS::Files;

# ABSTRACT: Irods files lookup

use Moose;
extends 'IRODS::Common';

has 'name'                          => ( is => 'ro', isa => 'Str', required   => 1 );
has 'file_containing_irods_output'  => ( is => 'ro', isa => 'Str'); # Used for testing, pass a file with output from IRODS

has 'file_locations'                => ( is => 'ro', isa => 'ArrayRef', lazy => 1, builder => '_build_file_locations' );
has 'irods_query'                   => ( is => 'ro', isa => 'Str', lazy => 1, builder => '_build_irods_query' );



sub _stream_location
{
  my ($self) = @_; 
  
  if($self->file_containing_irods_output)
  {
    # Used for testing, pass a file with output from IRODS
    return $self->file_containing_irods_output;
  }

  return $self->irods_query;
}


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

__PACKAGE__->meta->make_immutable;

no Moose;

1;
