package UpdatePipeline::PB::UpdateAllMetaData;

# ABSTRACT: Take in a list of study names, and a VRTracking database handle and update/create where IRODs differs to the tracking database

=head1 SYNOPSIS

my $pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => \@study_names, _vrtrack => $self->_vrtrack);
$pipeline->update();

=cut

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
use UpdatePipeline::PB::StudyFilesMetaData;

extends 'UpdatePipeline::CommonMetaDataManipulation';
with 'UpdatePipeline::CommonDatabaseSetup';
                           
has '_exception_handler'    => ( is => 'rw', lazy_build => 1,            isa => 'UpdatePipeline::ExceptionHandler' );
has '_config_settings'      => ( is => 'rw', lazy_build => 1,            isa => 'HashRef' );
                           
has 'verbose_output'        => ( is => 'rw', default    => 0,            isa => 'Bool');
has 'update_if_changed'     => ( is => 'rw', default    => 0,            isa => 'Bool');
has 'dont_use_warehouse'    => ( is => 'ro', default    => 0,            isa => 'Bool');
has 'use_supplier_name'     => ( is => 'ro', default    => 0,            isa => 'Bool');
has 'no_pending_lanes'      => ( is => 'ro', default    => 0,            isa => 'Bool');
has 'override_md5'          => ( is => 'ro', default    => 0,            isa => 'Bool');
has 'add_raw_reads'         => ( is => 'ro', default    => 0,            isa => 'Bool');
has 'specific_run_id'       => ( is => 'ro', default    => 0,            isa => 'Int');
has 'specific_min_run'      => ( is => 'ro', default    => 0,            isa => 'Int');
                           
has 'minimum_run_id'        => ( is => 'rw', default    => 1,            isa => 'Int' );
has 'environment'           => ( is => 'rw', default    => 'production', isa => 'Str');
has 'common_name_required'  => ( is => 'rw', default    => 1,            isa => 'Bool');
has 'taxon_id'              => ( is => 'rw', default    => 0,            isa => 'Int' );
has 'species_name'          => ( is => 'ro',                             isa => 'Maybe[Str]' );
has 'vrtrack_lanes'         => ( is => 'ro',                             isa => 'Maybe[HashRef]' );

has 'bin_directory' => (isa => 'Str', is => 'rw', default => '/software/irods/icommands/bin/');


sub _build__config_settings
{
   my ($self) = @_;
   \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}


sub _build__exception_handler
{
  my ($self) = @_;
  UpdatePipeline::ExceptionHandler->new( _vrtrack => $self->_vrtrack, minimum_run_id => $self->minimum_run_id, update_if_changed => $self->update_if_changed );
}

sub _generate_study_files_metadata
{
   my ($self,$study_names) = @_;
   return  UpdatePipeline::PB::StudyFilesMetaData->new(
       study_names        => $study_names,
       specific_min_run  => $self->specific_min_run
     )->files_metadata;
}

sub update
{
  my ($self) = @_;
  $self->_set_database_auto_reconnect;

  for my $file_metadata (@{$self->_generate_study_files_metadata($self->study_names )}) {
    if ($self->taxon_id && defined $self->species_name) {
    	$file_metadata->sample_common_name($self->species_name);
    }
    eval {
      
          $self->_update_lane($file_metadata) ;
    };
    if(my $exception = Exception::Class->caught())
    {
      $self->_exception_handler->add_exception($exception,$file_metadata->lane_name);
    }
  }
  $self->_exception_handler->print_report($self->verbose_output);
  1;
}

sub _update_lane
{
  my ($self, $file_metadata) = @_;
  
  return unless(defined($file_metadata->study_name));
  eval {
    my $vproject = UpdatePipeline::VRTrack::Project->new(name => $file_metadata->study_name, external_id => $file_metadata->study_ssid, data_access_group => $file_metadata->data_access_group, _vrtrack => $self->_vrtrack)->vr_project();
    if(defined($file_metadata->study_accession_number))
    {
      my $vstudy   = UpdatePipeline::VRTrack::Study->new(accession => $file_metadata->study_accession_number, _vr_project => $vproject)->vr_study();
      $vproject->update;
    }
    
    my $vr_sample = UpdatePipeline::VRTrack::Sample->new(
      common_name_required => $self->common_name_required,
      name => $file_metadata->sample_name,  
      external_id => $file_metadata->sample_ssid, 
      common_name => $file_metadata->sample_common_name, 
      accession => $file_metadata->sample_accession_number,
      supplier_name => $file_metadata->supplier_name,
      use_supplier_name => $self->use_supplier_name,
      taxon_id => $self->taxon_id,
      _vrtrack => $self->_vrtrack,
      _vr_project => $vproject)->vr_sample();
      
    my $vr_library = UpdatePipeline::VRTrack::Library->new(
      name => $file_metadata->library_name,
      _vrtrack           => $self->_vrtrack,
      _vr_sample         => $vr_sample)->vr_library();

    my $vr_lane = UpdatePipeline::VRTrack::Lane->new(
      name          => $file_metadata->lane_name,
      ebi_run_acc   => $file_metadata->ebi_run_acc,
      _vrtrack      => $self->_vrtrack,
      _vr_library   => $vr_library)->vr_lane();


    UpdatePipeline::VRTrack::File->new(
      name => $file_metadata->file_location,
      file_type => 5, 
      md5 => $file_metadata->md5 , 
      override_md5 => $self->override_md5, 
      _vrtrack => $self->_vrtrack,
      _vr_lane => $vr_lane)->vr_file();
      
  };
  if(my $exception = Exception::Class->caught())
  {
    $self->_exception_handler->add_exception($exception, $file_metadata->lane_name);
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

