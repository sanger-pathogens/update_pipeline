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
use Pathogens::ConfigSettings;
use Carp qw(croak);
use UpdatePipeline::Exceptions;

extends 'UpdatePipeline::CommonMetaDataManipulation';

has 'study_names'         => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has '_warehouse_dbh'      => ( is => 'rw',                lazy_build => 1 );

has 'report'              => ( is => 'rw', isa => 'HashRef',  lazy_build => 1 );
has 'inconsistent_files'  => ( is => 'rw', isa => 'HashRef' );
has 'environment'                   => ( is => 'rw', isa => 'Str', default => 'production');

has '_config_settings'              => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has '_database_settings'            => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

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


  #for new lanes that were recently changed, we do no comparison
  return if $self->_new_lane_changed_too_recently_to_compare({
                                                                 lane_metadata => $lane_metadata
                                                               , minimum_hours => 48
                                                             }
                                                            );

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

=head2 _new_lane_changed_too_recently_to_compare

 Usage     : $self->_new_lane_changed_too_recently_to_compare({
                                                                  lane_metadata  => $lane_metadata
                                                                , hour_threshold => 48
                                                              }
                                                             );
 Purpose   : This method should skip comparisons for new lanes (processed == 0) 
             with recent change (lane_changed date < hour_threshold).
 Returns   : (int) 1 for true or 0 for false.
 Argument  : Two named arguments: 
             1) (hash reference) lane_metadata: a lane metadata.
             2) (int) hour_threshold: a defines minimum timediff upon which to consider a lane as "non recent".
 Throws    : Nothing.
 Comment   : This method has been created to avoid comparing premature VRTrack lanes to their iRODS counterparts.
             lane datasets to their iRODS counterparts. A new lane is defined by a 'processed' value of 0.

=cut

sub _new_lane_changed_too_recently_to_compare
{
    my ($self, $args) = @_;
    my $lane_metadata = $args->{'lane_metadata'}  || croak 'no lane_metadata hashref provided';
    my $minimum_hours = $args->{'hour_threshold'} || croak 'no hour_threshold provided';
    if ($lane_metadata->{'lane_processed'} == 0) {
        if ( $lane_metadata->{'hours_since_lane_date_changed'} < 0 ) {
            UpdatePipeline::Exceptions::InvalidTimeDiff->throw(error=> 'an error');
        } 
        elsif ( $lane_metadata->{'hours_since_lane_date_changed'} >= $minimum_hours) {
            return 0; 
        } 
        elsif ( $lane_metadata->{'hours_since_lane_date_changed'} < $minimum_hours ) {
            return 1;
        } 
    } else {
        return 0;
    }
}


1;



