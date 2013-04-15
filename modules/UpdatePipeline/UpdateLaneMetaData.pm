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

has 'lane_meta_data'       => ( is => 'ro', isa => "Maybe[HashRef]");
has 'file_meta_data'       => ( is => 'ro', isa => 'UpdatePipeline::FileMetaData',   required => 1 );

has 'common_name_required'  => ( is => 'ro', isa => 'Bool', default => 1);

sub update_required
{
  my($self) = @_;
  
  return $self->_differences_between_file_and_lane_meta_data;
}

sub _differences_between_file_and_lane_meta_data
{
  my ($self) = @_;
  
  # ignore files where there are only a few reads, its usually bad data
  return 0 if (defined($self->file_meta_data->total_reads ) && $self->file_meta_data->total_reads < 10000);
  
  # to stop exception being thrown where the common name is missing from the file metadata, but is not required
  $self->file_meta_data->sample_common_name('default') if (! $self->common_name_required && not defined $self->file_meta_data->sample_common_name);
  
  UpdatePipeline::Exceptions::UndefinedSampleName->throw( error => $self->file_meta_data->file_name) if(not defined($self->file_meta_data->sample_name));
  UpdatePipeline::Exceptions::UndefinedSampleCommonName->throw( error => $self->file_meta_data->sample_name) if($self->common_name_required == 1 && not defined($self->file_meta_data->sample_common_name));
  UpdatePipeline::Exceptions::UndefinedStudySSID->throw( error => $self->file_meta_data->file_name) if(not defined($self->file_meta_data->study_ssid));
  UpdatePipeline::Exceptions::UndefinedLibraryName->throw( error => $self->file_meta_data->file_name) if(not defined($self->file_meta_data->library_name));
  

  return 1 unless(defined $self->lane_meta_data);

  my @required_keys = ("sample_name", "study_name","library_name", "total_reads","sample_accession_number","study_accession_number", "sample_common_name", "fragment_size_from","fragment_size_to");
  for my $required_key (@required_keys)
  {
    return 1 unless defined($self->lane_meta_data->{$required_key});
  }
  
  # attributes used in directory structure
  my @fields_in_path_to_lane = $self->common_name_required ? ("library_name","sample_common_name", "study_ssid") : ("library_name", "study_ssid");
  for my $field_name  (@fields_in_path_to_lane)
  {
    if(defined($self->file_meta_data->$field_name) && defined($self->lane_meta_data->{$field_name})
       && $self->file_meta_data->$field_name ne $self->lane_meta_data->{$field_name}) 
    {
	  my $error_message = "Mismatched data for ".$self->file_meta_data->file_name_without_extension." [$field_name]: iRODS (".$self->file_meta_data->$field_name."), vrtrack (".$self->lane_meta_data->{$field_name}.")";
      UpdatePipeline::Exceptions::PathToLaneChanged->throw( error => $error_message );
    }
  }

  # check to see if sample name has changed
  if(defined($self->file_meta_data->sample_name) && defined($self->lane_meta_data->{sample_name})
     && $self->_normalise_sample_name($self->file_meta_data->sample_name) ne $self->_normalise_sample_name($self->lane_meta_data->{sample_name}) )
  { 
	my $error_message = "Mismatched data for ".$self->file_meta_data->file_name_without_extension." [sample name]: iRODS (".$self->_normalise_sample_name($self->file_meta_data->sample_name)."), vrtrack (".$self->_normalise_sample_name($self->lane_meta_data->{sample_name}).")";
    UpdatePipeline::Exceptions::PathToLaneChanged->throw( error => $error_message );
  }

  my @fields_to_check_file_defined_and_not_equal =  $self->common_name_required ? ("study_name", "library_name","sample_common_name", "study_accession_number","sample_accession_number","library_ssid", "lane_is_paired_read","lane_manual_qc", "study_ssid","sample_ssid") : ("study_name", "library_name", "study_accession_number","sample_accession_number","library_ssid", "lane_is_paired_read","lane_manual_qc", "study_ssid","sample_ssid");
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
  elsif( defined($self->file_meta_data->total_reads ) && $self->file_meta_data->total_reads > 10000 && $self->lane_meta_data->{lane_processed} > 0 &&   !( $self->file_meta_data->total_reads >= $self->lane_meta_data->{total_reads}*0.95  && $self->file_meta_data->total_reads <= $self->lane_meta_data->{total_reads}*1.05 ) )
  {
    UpdatePipeline::Exceptions::TotalReadsMismatch->throw( error => $self->file_meta_data->file_name_without_extension );
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

__PACKAGE__->meta->make_immutable;

no Moose;

1;
