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
has 'file_type'             => ( is => 'ro', default    => 'bam',        isa => 'Str');

sub _build_irods_query
{
  my ($self) = @_;
  my $no_pending_lanes_str = '';
  if($self->no_pending_lanes == 1 )
  {
    $no_pending_lanes_str = ' and manual_qc like "%"';
  }

  return $self->bin_directory . "imeta qu -z seq -d target = 1 ".$no_pending_lanes_str." and type = ".$self->file_type." and total_reads != 0 and study = '".$self->name."' |";
}


__PACKAGE__->meta->make_immutable;

no Moose;

1;
