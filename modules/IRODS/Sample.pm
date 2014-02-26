package IRODS::Sample;
# ABSTRACT: Take in a sample name and look up all files assosiated with it.

=head1 SYNOPSIS

Take in a sample name and look up all files assosiated with it.
   use IRODS::Sample;
   
   my $obj = IRODS::Sample->new(
       name        => 'ABC',
     );
   $obj->file_locations();

=cut


use Moose;
extends 'IRODS::Files';

sub _build_irods_query
{
  my ($self) = @_; 

  return $self->bin_directory . "imeta qu -z seq -d sample = '".$self->name."' |";
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
