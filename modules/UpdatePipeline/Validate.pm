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
use UpdatePipeline::CheckReadConsistency;
use Pathogens::ConfigSettings;

extends 'UpdatePipeline::CommonMetaDataManipulation';

has 'study_names'         => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has '_warehouse_dbh'      => ( is => 'rw',                lazy_build => 1 );

has 'report'              => ( is => 'rw', isa => 'HashRef',  lazy_build => 1 );
has 'inconsistent_files'  => ( is => 'rw', isa => 'HashRef' );
has 'environment'                   => ( is => 'rw', isa => 'Str', default => 'production');

has '_config_settings'              => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has '_database_settings'            => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

has '_consistency_evaluator'        => ( is => 'rw', isa => 'UpdatePipeline::CheckReadConsistency', lazy_build => 1 );
has 'request_for_read_count_consistency_evaluation' => (is => 'rw', isa => 'Bool', default => undef);
has 'list_all_missing_lanes' => (is => 'rw', isa => 'Bool', default => 0);

sub _build__config_settings
{
   my ($self) = @_;
   \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}

sub _build__database_settings
{
  my ($self) = @_;
  \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'database.yml')->settings()};
}

sub _build__consistency_evaluator 
{
    my ($self) = @_;
    return UpdatePipeline::CheckReadConsistency->new( _vrtrack => $self->_vrtrack );
}

sub _build__warehouse_dbh
{
  my ($self) = @_;
  Warehouse::Database->new(settings => $self->_database_settings->{warehouse})->connect;
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
      if($file_metadata->total_reads > 10000 && ($file_metadata->lane_manual_qc ne 'pending' || $self->list_all_missing_lanes))
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
   
   $self->_filter_by_run_id(6500, "files_missing_from_tracking");
   
   $self->_filter_by_run_id(6500, "irods_missing_sample_name");
   $self->_filter_by_run_id(6500, "irods_missing_study_name");
   $self->_filter_by_run_id(6500, "irods_missing_library_name");
   $self->_filter_by_run_id(6500, "irods_missing_total_reads");
   
   $self->_filter_by_run_id(6500, "missing_sample_name_in_tracking");
   $self->_filter_by_run_id(6500, "missing_study_name_in_tracking");
   $self->_filter_by_run_id(6500, "missing_library_name_in_tracking");
   $self->_filter_by_run_id(6500, "missing_total_reads_in_tracking");
   
   $self->_filter_by_run_id(6500, "inconsistent_sample_name_in_tracking");
   $self->_filter_by_run_id(6500, "inconsistent_study_name_in_tracking");
   $self->_filter_by_run_id(6500, "inconsistent_library_name_in_tracking");
   $self->_filter_by_run_id(6500, "inconsistent_number_of_reads_in_tracking");
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

  #We silently pass when dealing with new lanes that were recently changed
  return if $self->_new_lane_changed_too_recently_to_compare( {lane_metadata  => $lane_metadata, hour_threshold => $self->_config_settings->{'minimum_passed_hours_before_comparing_new_lanes_to_irods'} } );

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
  elsif( defined($file_metadata->total_reads) && $self->request_for_read_count_consistency_evaluation ) 
  {
    if ( not $self->_irods_and_vrtrack_read_counts_are_consistent($lane_metadata->{lane_name}, $file_metadata->total_reads) ) {
      return "read_count_discrepancy_between_irods_and_vrtrack_filesystem";
    }
  }
  
  return;

}

#Checks if the iRODS has the some read count as the vrtrack file system for this lane.
#The "_irods_and_vrtrack_read_counts_are_consistent" will return 0 when dealing with a 
#lane that has no valid gzipped fastq file on the vrtrack file-system.

sub _irods_and_vrtrack_read_counts_are_consistent {

    my ($self, $lane_name, $irods_read_count) = @_;

    my $evaluation_result;
#Try
    eval 
    {
      $evaluation_result = $self->_consistency_evaluator->read_counts_are_consistent( {lane_name => $lane_name, irods_read_count => $irods_read_count} ); 
    };

#Catch
    my $error;
    if ( $error = Exception::Class->caught( 'UpdatePipeline::Exceptions::CommandFailed' ) 
            or
         $error = Exception::Class->caught( 'UpdatePipeline::Exceptions::FileNotFound' ) 
       )
    {
      
      $evaluation_result = 0; #set read counts explicitly as inconsistent in cases of errors

    } 
    elsif ( Exception::Class->caught() ) #unexpected, dies here!
    {
       $error = Exception::Class->caught();
       ref $error ? $error->rethrow : die $error;
    } 

    return $evaluation_result;

}

=head2 _new_lane_changed_too_recently_to_compare

 Usage     : $self->_new_lane_changed_too_recently_to_compare( {lane_metadata  => $lane_metadata, hour_threshold => 48} );
 Purpose   : This method will return true (1) for new lanes with recent lane_changed date
 Returns   : (Int) 1 for true or 0 for false.
 Argument  : 1) (HashReference) lane_metadata: a lane metadata.
             2) (Int) hour_threshold: lane is recent if the time difference between now and its lane_changed date (in VRTrack DB) is below this threshold
 Comment   : This method has been created to avoid comparing premature VRTrack lanes to their iRODS counterparts.
             A new lane has a 'processed' (in VRTrack DB) value of 0.

=cut

sub _new_lane_changed_too_recently_to_compare
{
    my ($self, $args) = @_;   

    if (not defined $args->{'hour_threshold'}) { 
        if (defined $self->_config_settings->{'minimum_passed_hours_before_comparing_new_lanes_to_irods'}
                and $self->_config_settings->{'minimum_passed_hours_before_comparing_new_lanes_to_irods'} > 0)            
        {
            #see if we can find a default value in the config.yml
            $args->{'hour_threshold'} = $self->_config_settings->{'minimum_passed_hours_before_comparing_new_lanes_to_irods'}; 
        } else {
            #last resort: set it to 48 hours...
            $args->{'hour_threshold'} = 48;
        }
    }

    #the lane is new
    if ($args->{'lane_metadata'}->{'lane_processed'} == 0) {
        #this is a strange case, the lane_changed happens in the future? default response: too recent to compare
        if ( $args->{'lane_metadata'}->{'hours_since_lane_changed'} < 0 ) {
            return 1;
        } 
        #the new lane has been changed long ago, it is not considered 'recent' anymore
        elsif ( $args->{'lane_metadata'}->{'hours_since_lane_changed'} >= $args->{'hour_threshold'}) {
            return 0; 
        } 
        #the new lane is too fresh, consider it too recent to compare
        elsif ( $args->{'lane_metadata'}->{'hours_since_lane_changed'} < $args->{'hour_threshold'} ) {
            return 1;
        }
    #not a new lane
    } else {
        return 0;
    }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
