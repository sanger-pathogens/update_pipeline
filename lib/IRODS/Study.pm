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
has 'file_type'             => ( is => 'ro', default    => 'cram',        isa => 'Str');
has 'specific_min_run'      => ( is => 'ro', default    => 0,            isa => 'Int');


sub _build_irods_query
{
  my ($self) = @_;
  if($self->file_type eq 'cram')
  {
  	return $self->_illumina_irods_query;
  }
  elsif($self->file_type eq 'h5')
  {
  	return $self->_pacbio_irods_query;
  }
  else
  {
        return undef;	
  }
}


sub _illumina_irods_query
{
  my ($self) = @_;
  my $no_pending_lanes_str = '';
  if($self->no_pending_lanes == 1 )
  {
    $no_pending_lanes_str = ' and manual_qc like "%"';
  }
  
  my $specific_min_run_str = '';
  if($self->specific_min_run > 0)
  {
   $specific_min_run_str = "and id_run '>=' ".$self->specific_min_run;
  }

  return $self->bin_directory . "imeta qu -z seq -d target = 1 and study = '".$self->name."' $no_pending_lanes_str and type = ".$self->file_type." $specific_min_run_str and total_reads != 0  |";
}



sub _pacbio_irods_query
{
  my ($self) = @_;
  
  my $specific_min_run_str = '';
  if($self->specific_min_run > 0)
  {
   $specific_min_run_str = "and run 'n>=' ".$self->specific_min_run;
  }

  return $self->bin_directory . "imeta qu -z seq -d type = ".$self->file_type." $specific_min_run_str and study = '".$self->name."' |";
}




__PACKAGE__->meta->make_immutable;

no Moose;

1;
