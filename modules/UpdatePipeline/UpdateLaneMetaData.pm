=head1 NAME

UpdatePipeline::UpdateLaneMetaData.pm   - Take in a LaneMetaData object and a FileMetaData object, and create/update as needed in VRTrack

=head1 SYNOPSIS
use UpdatePipeline::UpdateLaneMetaData;
my $update_lane_metadata = UpdatePipeline::UpdateLaneMetaData->new(
  lane_meta_data => $lanemetadata,
  file_meta_data => $filemetadata,
  );
$update_lane_metadata->update_required;

=cut
package UpdatePipeline::UpdateLaneMetaData;
use Moose;
use UpdatePipeline::VRTrack::LaneMetaData;
use UpdatePipeline::FileMetaData;

has 'lane_meta_data'  => ( is => 'ro', isa => "Maybe[HashRef]");
has 'file_meta_data'  => ( is => 'ro', isa => 'UpdatePipeline::FileMetaData',                required => 1 );

sub update_required
{
  my($self) = @_;
  return 1 unless(defined $self->lane_meta_data);
  return $self->_differences_between_file_and_lane_meta_data;
}

sub _differences_between_file_and_lane_meta_data
{
  my ($self) = @_;
  
  my @minimum_required_fields = ("sample_name", "study_name","library_name", "sample_common_name");
  for my $required_field (@minimum_required_fields)
  {
     UpdatePipeline::Exceptions::EssentialFileMetaDataMissing->throw( error => "Missing $required_field for ".$self->file_meta_data->file_name."\n") if(not defined($self->file_meta_data->$required_field));
  }

  my @required_keys = ("sample_name", "study_name","library_name", "total_reads","sample_accession_number","study_accession_number", "sample_common_name");
  for my $required_key (@required_keys)
  {
    return 1 unless defined($self->lane_meta_data->{$required_key});
  }

  my @fields_to_check_file_defined_and_not_equal = ("study_name", "library_name","sample_common_name", "study_accession_number","sample_accession_number","library_ssid", "lane_is_paired_read","lane_manual_qc", "study_ssid","sample_ssid");
  for my $field_name (@fields_to_check_file_defined_and_not_equal)
  {
    if( $self->_file_defined_and_not_equal($self->file_meta_data->$field_name, $self->lane_meta_data->{$field_name}) )
    {
      return 1;
    }
  }
  
  if( $self->_file_defined_and_not_equal($self->_normalise_sample_name($self->file_meta_data->sample_name), $self->_normalise_sample_name($self->lane_meta_data->{sample_name})))
  {
    return 1;
  }
  elsif( defined($self->file_meta_data->total_reads ) && $self->file_meta_data->total_reads > 10000 && !( $self->file_meta_data->total_reads >= $self->lane_meta_data->{total_reads}*0.98  && $self->file_meta_data->total_reads <= $self->lane_meta_data->{total_reads}*1.02 ) )
  {
    UpdatePipeline::Exceptions::TotalReadsMismatch->throw( error => $self->file_meta_data->file_name_without_extension." has an inconsistent number of reads\n" );
  }

  return 0; 
}

sub _file_defined_and_not_equal
{
  my ($self, $file_meta_data, $lane_metadata) = @_;
  return 1 if(defined($file_meta_data) && ! defined($lane_metadata));
  (defined($file_meta_data) && $file_meta_data ne $lane_metadata) ? 1 : 0;
}

sub _normalise_sample_name
{
  my ($self, $sample_name) = @_;
  $sample_name =~ s/\W/_/g;
  return $sample_name;
}


1;