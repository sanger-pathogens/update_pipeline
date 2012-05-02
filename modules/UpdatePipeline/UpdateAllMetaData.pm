=head1 NAME

UpdatePipeline::UpdateAllMetaData.pm   - Take in a list of study names, and a VRTracking database handle and update/create where IRODs differs to the tracking database

=head1 SYNOPSIS

my $pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => \@study_names, _vrtrack => $self->_vrtrack);
$pipeline->update();

=cut
package UpdatePipeline::UpdateAllMetaData;
use Moose;
use UpdatePipeline::IRODS;
use UpdatePipeline::VRTrack::LaneMetaData;
use UpdatePipeline::UpdateLaneMetaData;
use UpdatePipeline::VRTrack::Project;
use UpdatePipeline::VRTrack::Sample;
use UpdatePipeline::VRTrack::Library;
use UpdatePipeline::VRTrack::Lane;
use UpdatePipeline::VRTrack::File;
use UpdatePipeline::VRTrack::Study;
use UpdatePipeline::ExceptionHandler;
use Pathogens::ConfigSettings;

extends 'UpdatePipeline::CommonMetaDataManipulation';

has 'study_names'         => ( is => 'rw', isa => 'ArrayRef', required   => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has '_exception_handler'  => ( is => 'rw', isa => 'UpdatePipeline::ExceptionHandler', lazy_build => 1 );
has 'verbose_output'      => ( is => 'rw', isa => 'Bool', default    => 0);
has 'update_if_changed'   => ( is => 'rw', isa => 'Bool', default    => 0 );
has '_warehouse_dbh'      => ( is => 'rw',                lazy_build => 1 );
has 'minimum_run_id'      => ( is => 'rw', isa => "Int");
has 'environment'         => ( is => 'rw', isa => 'Str', default => 'production');
                          
has '_config_settings'    => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has '_database_settings'  => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );


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

sub _build__exception_handler
{
  my ($self) = @_;
  UpdatePipeline::ExceptionHandler->new( _vrtrack => $self->_vrtrack, minimum_run_id => $self->minimum_run_id, update_if_changed => $self->update_if_changed); 
}


sub update
{
  my ($self) = @_;

  for my $file_metadata (@{$self->_files_metadata})
  {
    eval {
      if(UpdatePipeline::UpdateLaneMetaData->new(
          lane_meta_data => $self->_lanes_metadata->{$file_metadata->file_name_without_extension},
          file_meta_data => $file_metadata)->update_required
        )
      {
          $self->_post_populate_file_metadata($file_metadata);
          $self->_update_lane($file_metadata);
      }
    };
    if(my $exception = Exception::Class->caught())
    { 
      $self->_exception_handler->add_exception($exception,$file_metadata->file_name_without_extension);
    }
  }
  $self->_exception_handler->print_report($self->verbose_output);
  
  1;
}

sub _update_lane
{
  my ($self, $file_metadata) = @_;
  eval {
          
    my $vproject = UpdatePipeline::VRTrack::Project->new(name => $file_metadata->study_name, external_id => $file_metadata->study_ssid, _vrtrack => $self->_vrtrack)->vr_project();
    if(defined($file_metadata->study_accession_number))
    {
      my $vstudy   = UpdatePipeline::VRTrack::Study->new(accession => $file_metadata->study_accession_number, _vr_project => $vproject)->vr_study();
      $vproject->update;
    }
    my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => $file_metadata->sample_name,  external_id => $file_metadata->sample_ssid, common_name => $file_metadata->sample_common_name, accession => $file_metadata->sample_accession_number, _vrtrack => $self->_vrtrack,_vr_project => $vproject)->vr_sample();
    my $vr_library = UpdatePipeline::VRTrack::Library->new(
      name => $file_metadata->library_name, 
      external_id        => $file_metadata->library_ssid, 
      fragment_size_from => $file_metadata->fragment_size_from,
      fragment_size_to   => $file_metadata->fragment_size_to,
      _vrtrack           => $self->_vrtrack,
      _vr_sample         => $vr_sample)->vr_library();
    
    my $vr_lane = UpdatePipeline::VRTrack::Lane->new(
      name          => $file_metadata->file_name_without_extension,
      paired        => $file_metadata->lane_is_paired_read,
      npg_qc_status => $file_metadata->lane_manual_qc,
      _vrtrack      => $self->_vrtrack,
      _vr_library   => $vr_library)->vr_lane();
    
    my $vr_file = UpdatePipeline::VRTrack::File->new(name => $file_metadata->file_name ,type => $file_metadata->file_type_number($file_metadata->file_type), md5 => $file_metadata->file_md5 ,_vrtrack => $self->_vrtrack,_vr_lane => $vr_lane)->vr_file();
  };
  if(my $exception = Exception::Class->caught())
  { 
    $self->_exception_handler->add_exception($exception, $file_metadata->file_name_without_extension);
  }
}

sub _post_populate_file_metadata
{
  my ($self, $file_metadata) = @_;
  Warehouse::FileMetaDataPopulation->new(file_meta_data => $file_metadata, _dbh => $self->_warehouse_dbh)->post_populate();
}


1;

