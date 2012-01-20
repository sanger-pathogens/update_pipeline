=head1 NAME

UpdatePipeline::Validate.pm   - Take in a list of study names, and a VRTracking database handle and produce a report on the current state of the data in the pipeline compared to IRODS

=head1 SYNOPSIS

my $validate_pipeline = UpdatePipeline::Validate->new(study_names => \@study_names, _vrtrack => $vrtrack);
$validate_pipeline->report();

=cut
package UpdatePipeline::Validate;
use Moose;
use UpdatePipeline::IRODS;
use UpdatePipeline::VRTrack::LaneMetaData;

has 'study_names'  => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'     => ( is => 'rw', required => 1 );

has '_files_metadata'  => ( is => 'rw',  isa => 'ArrayRef', lazy_build => 1 );
has '_lanes_metadata'  => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

has 'report'  => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has 'inconsistent_files'  => ( is => 'rw', isa => 'HashRef' );

sub _build__files_metadata
{
  my ($self) = @_;
  my $irods_files_metadata = UpdatePipeline::IRODS->new(
    study_names => $self->study_names
    )->files_metadata();
  return $irods_files_metadata;
}

sub _build__lanes_metadata
{
  my ($self) = @_;
  my %lanes_metadata;
  for my $file_metadata (@{$self->_files_metadata})
  {
    $lanes_metadata{$file_metadata->file_name_without_extension} = UpdatePipeline::VRTrack::LaneMetaData->new(
      name => $file_metadata->file_name_without_extension, 
      _vrtrack => $self->_vrtrack
    )->lane_attributes();
  }
  return \%lanes_metadata;
}


sub _build_report
{
  my ($self) = @_;
  my %report;
  my %inconsistent_files;
  
  $report{files_missing_from_tracking} = 0;
  $report{total_files_in_irods} = 0;
  $report{num_inconsistent} = 0;
  $inconsistent_files{files_missing_from_tracking} = ();
  
  for my $file_metadata (@{$self->_files_metadata})
  {
    
    
    # theres a problem where lanes are in the database but havent imported at all on to disk?
    
    
    if($self->_lanes_metadata->{$file_metadata->file_name_without_extension})
    {
      my $consistency_value = $self->_compare_file_metadata_with_vrtrack_lane_metadata($file_metadata, $self->_lanes_metadata->{$file_metadata->file_name_without_extension} );
      if( defined($consistency_value) )
      {
        #inconsitent data
        $report{$consistency_value} = 0 unless defined($report{$consistency_value});
        $report{$consistency_value}++;
        
        $inconsistent_files{$consistency_value} = () unless defined($inconsistent_files{$consistency_value});
        push(@{$inconsistent_files{$consistency_value}}, $file_metadata->file_name_without_extension);
        
        $report{num_inconsistent}++;
      }
      else
      {
        # everything is okay
      }
      
    }
    else
    {
      # file missing from tracking database
      if($file_metadata->total_reads > 10000)
      {
        push(@{$inconsistent_files{files_missing_from_tracking}}, $file_metadata->file_name_without_extension);
      }
      $report{files_missing_from_tracking}++;
    }
    $report{total_files_in_irods}++;
  }

  $self->inconsistent_files(\%inconsistent_files);
  $self->_filter_inconsistencies();
  
  return \%report;
}

sub _filter_inconsistencies
{
   my ($self) = @_;
   
   $self->_filter_by_run_id(6000, "files_missing_from_tracking");
   
   $self->_filter_by_run_id(6000, "irods_missing_sample_name");
   $self->_filter_by_run_id(6000, "irods_missing_study_name");
   $self->_filter_by_run_id(6000, "irods_missing_library_name");
   $self->_filter_by_run_id(6000, "irods_missing_total_reads");
   
   $self->_filter_by_run_id(6000, "missing_sample_name_in_tracking");
   $self->_filter_by_run_id(6000, "missing_study_name_in_tracking");
   $self->_filter_by_run_id(6000, "missing_library_name_in_tracking");
   $self->_filter_by_run_id(6000, "missing_total_reads_in_tracking");
   
   $self->_filter_by_run_id(3000, "inconsistent_sample_name_in_tracking");
   $self->_filter_by_run_id(4000, "inconsistent_study_name_in_tracking");
   $self->_filter_by_run_id(6000, "inconsistent_library_name_in_tracking");
   $self->_filter_by_run_id(4000, "inconsistent_number_of_reads_in_tracking");
}

sub _filter_by_run_id
{
  my ($self, $run_id_threshold, $key) = @_;
  
  my @files_missing =();
  return unless defined($self->inconsistent_files->{$key});
  for my $filename (@{$self->inconsistent_files->{$key}})
  {
    if( $filename =~ m/^(\d+)_/)
    {
      my $run_id = $1;
      push(@files_missing, $filename) if($run_id > $run_id_threshold );
    }
  }
  my @sorted_file_names = sort {$b cmp $a} @files_missing;
  $self->inconsistent_files->{$key} = \@sorted_file_names;
  
}

sub _compare_file_metadata_with_vrtrack_lane_metadata
{
  my ($self, $file_metadata, $lane_metadata) = @_;
  
  return "irods_missing_sample_name"  unless defined($file_metadata->{sample_name});
  return "irods_missing_study_name"   unless defined($file_metadata->{study_name});
  return "irods_missing_library_name" unless defined($file_metadata->{library_name});
  return "irods_missing_total_reads"  unless defined($file_metadata->{total_reads});
  
  return "missing_sample_name_in_tracking"  unless defined($lane_metadata->{sample_name});
  return "missing_study_name_in_tracking"   unless defined($lane_metadata->{study_name});
  return "missing_library_name_in_tracking" unless defined($lane_metadata->{library_name});
  return "missing_total_reads_in_tracking"  unless defined($lane_metadata->{total_reads});
  
  my $f_sample_name = $file_metadata->sample_name;
  $f_sample_name =~ s/\W/_/g;
  my $l_sample_name = $lane_metadata->{sample_name};
  $l_sample_name =~ s/\W/_/g;
  
  if( defined($f_sample_name) && $f_sample_name ne $l_sample_name)
  {
    return "inconsistent_sample_name_in_tracking";
  }
  elsif( defined($file_metadata->study_name ) && $file_metadata->study_name ne $lane_metadata->{study_name} )
  {
    return "inconsistent_study_name_in_tracking";
  } 
  elsif( defined($file_metadata->library_name ) && $file_metadata->library_name ne $lane_metadata->{library_name} )
  {
    return "inconsistent_library_name_in_tracking";
  }
  elsif( defined($file_metadata->total_reads ) && $file_metadata->total_reads > 10000 && !( $file_metadata->total_reads >= $lane_metadata->{total_reads}*0.9  && $file_metadata->total_reads <= $lane_metadata->{total_reads}*1.1 ) )
  {
    return "inconsistent_number_of_reads_in_tracking";
  }
  
  return;
}

1;



