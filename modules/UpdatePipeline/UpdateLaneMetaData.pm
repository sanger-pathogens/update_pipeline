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

has 'lane_meta_data'  => ( is => 'ro', isa => 'Maybe[UpdatePipeline::VRTrack::LaneMetaData]' );
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
    return 1 unless defined($self->lane_meta_data->lane_attributes->{$required_key});
  }

  my $f_sample_name = $self->_normalise_sample_name($self->file_meta_data->sample_name);
  my $l_sample_name = $self->_normalise_sample_name($self->lane_meta_data->lane_attributes->{sample_name});

  if( $self->_file_defined_and_not_equal($f_sample_name, $l_sample_name))
  {
    return 1;
  }
  elsif( $self->_file_defined_and_not_equal($self->file_meta_data->study_name, $self->lane_meta_data->lane_attributes->{study_name}) )
  {
    return 1;
  } 
  elsif($self->_file_defined_and_not_equal($self->file_meta_data->library_name, $self->lane_meta_data->lane_attributes->{library_name}) )
  {
    return 1;
  }
  elsif($self->_file_defined_and_not_equal($self->file_meta_data->sample_common_name, $self->lane_meta_data->lane_attributes->{sample_common_name}) )
  {
    return 1;
  }
  elsif($self->_file_defined_and_not_equal($self->file_meta_data->study_accession_number, $self->lane_meta_data->lane_attributes->{study_accession_number}) )
  {
    return 1;
  }
  elsif($self->_file_defined_and_not_equal($self->file_meta_data->sample_accession_number, $self->lane_meta_data->lane_attributes->{sample_accession_number}) )
  {
    return 1;
  }
  elsif( defined($self->file_meta_data->total_reads ) && $self->file_meta_data->total_reads > 10000 && !( $self->file_meta_data->total_reads >= $self->lane_meta_data->lane_attributes->{total_reads}*0.9  && $self->file_meta_data->total_reads <= $self->lane_meta_data->lane_attributes->{total_reads}*1.1 ) )
  {
    return 1;
  }
  elsif($self->_file_and_lane_defined_and_not_equal($self->file_meta_data->study_accession_number,$self->lane_meta_data->lane_attributes->{study_accession_number} ))
  {
    return 1;
  }
  elsif($self->_file_and_lane_defined_and_not_equal($self->file_meta_data->library_ssid,$self->lane_meta_data->lane_attributes->{library_ssid} ))
  {
    return 1;
  }
  elsif($self->_file_and_lane_defined_and_not_equal($self->file_meta_data->sample_accession_number,$self->lane_meta_data->lane_attributes->{sample_accession_number} ))
  {
    return 1;
  }
  elsif($self->_file_and_lane_defined_and_not_equal($self->file_meta_data->lane_is_paired_read,$self->lane_meta_data->lane_attributes->{lane_is_paired_read} ))
  {
    return 1;
  }
  elsif($self->_file_and_lane_defined_and_not_equal($self->file_meta_data->lane_manual_qc,$self->lane_meta_data->lane_attributes->{lane_manual_qc} ))
  {
    return 1;
  }

  #elsif($self->_file_defined_and_not_equal($self->file_meta_data->file_md5,$self->file_meta_data->file_md5 ))
  #{
  #  # only do this if the lane has not been imported previously
  #  #UpdatePipeline::Exceptions::FileMD5Changed->throw( error => "File ".$self->file_meta_data->file_name." MD5 changed from ".$self->file_meta_data->file_md5." to ".$self->file_meta_data->file_md5." so need to reimport\n" );
  #}

  return 0; 
}

sub _file_and_lane_defined_and_not_equal
{
  my ($self, $file_meta_data, $lane_metadata) = @_;
  (defined($file_meta_data) && defined($lane_metadata) && $file_meta_data ne $lane_metadata) ? 1 : 0;
}

sub _file_defined_and_not_equal
{
  my ($self, $file_meta_data, $lane_metadata) = @_;
  (defined($file_meta_data) && $file_meta_data ne $lane_metadata) ? 1 : 0;
}

sub _normalise_sample_name
{
  my ($self, $sample_name) = @_;
  $sample_name =~ s/\W/_/g;
  return $sample_name;
}


1;