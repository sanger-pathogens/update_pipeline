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
extends 'IRODS::Files';

sub _build_irods_query
{
  my ($self) = @_; 
  return $self->bin_directory . "imeta qu -z seq -d study = '".$self->name."' and target = 1 and total_reads != 0 |";
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
