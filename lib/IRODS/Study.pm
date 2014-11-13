package IRODS::Study;
# ABSTRACT: lookup a study in irods
=head1 SYNOPSIS

use IRODS::Study;
my $study = IRODS::Study->new(
  name => 'My Study'
  );

my @file_locations = $study->file_locations();

=cut
use Moose;
extends 'IRODS::Files';

has 'no_pending_lanes'      => ( is => 'ro', default    => 0,            isa => 'Bool');

sub _build_irods_query
{
  my ($self) = @_;
  my $no_pending_lanes_str = '';
  if($self->no_pending_lanes == 1 )
  {
    $no_pending_lanes_str = ' and manual_qc like "%"';
  }
  return $self->bin_directory . "imeta qu -z seq -d study = '".$self->name."' and type = bam and target = 1 and total_reads != 0".$no_pending_lanes_str." |";
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
