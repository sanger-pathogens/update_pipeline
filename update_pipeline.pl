#!/usr/bin/env perl

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 CONTACT
=head1 METHODS

=cut

BEGIN { unshift(@INC, './modules') }
use strict;
use warnings;
no warnings 'uninitialized';
use POSIX;
use Getopt::Long;
use VRTrack::VRTrack;
use VRTrack::Lane;
use VertRes::Utils::VRTrackFactory;
use NCBI::SimpleLookup;
use NCBI::TaxonLookup;
use Parallel::ForkManager;

use UpdatePipeline::UpdateAllMetaData;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $number_of_files_to_return, $lock_file, $parallel_processes, $verbose_output, $errors_min_run_id, $database,$input_study_name, $update_if_changed, $dont_use_warehouse, $taxon_id, $overwrite_common_name, $use_supplier_name, $specific_run_id, $specific_min_run, $common_name_required, $no_pending_lanes, $species_name, $override_md5, $withdraw_del, $vrtrack_lanes, $total_reads );

GetOptions(
    's|studies=s'               => \$studyfile,
    'n|study_name=s'            => \$input_study_name,
    'd|database=s'              => \$database,
    'f|max_files_to_return=s'   => \$number_of_files_to_return,
    'p|parallel_processes=s'    => \$parallel_processes,
    'v|verbose'                 => \$verbose_output,
    'r|min_run_id=s'            => \$errors_min_run_id,
    'u|update_if_changed'       => \$update_if_changed,
    'w|dont_use_warehouse'      => \$dont_use_warehouse,
    'tax|taxon_id=i'            => \$taxon_id,
    'sup|use_supplier_name'     => \$use_supplier_name,
    'run|specific_run_id=i'     => \$specific_run_id,
    'min|specific_min_run=i'     => \$specific_min_run,    
    'nop|no_pending_lanes'      => \$no_pending_lanes,
    'md5|override_md5'          => \$override_md5,
    'wdr|withdraw_del'          => \$withdraw_del,
    'trd|include_total_reads'   => \$total_reads,    
    'l|lock_file=s'             => \$lock_file,
    'h|help'                    => \$help,
);

my $db = $database ;

( ($studyfile || $input_study_name) &&  $db && !$help ) or die <<USAGE;
Usage: $0   
  -s|--studies                 <file of study names>
  -n|--study_name              <a single study name to update>
  -d|--database                <vrtrack database name>
  -f|--max_files_to_return     <optional limit on num of file to check per process>
  -p|--parallel_processes      <optional number of processes to run in parallel, defaults to 1>
  -v|--verbose                 <print out debugging information>
  -r|--min_run_id              <optionally filter out errors below this run_id, defaults to 6000>
  -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>
  -w|--dont_use_warehouse      <dont use the warehouse to fill in missing data>
  -tax|--taxon_id              <optionally provide taxon id to overwrite species info in bam file common name>
  -sup|--use_supplier_name     <optionally use the supplier name from the warehouse to populate name and hierarchy name of the individual table>
  -run|--specific_run_id       <optionally provide a specfic run id for a study>
  -min|--specific_min_run      <optionally provide a specfic minimum run id for a study to import>  
  -nop|--no_pending_lanes      <optionally filter out lanes whose npg QC status is pending>
  -md5|--override_md5          <optionally update md5 on imported file if the iRODS md5 changes>
  -wdr|--withdraw_del          <optionally withdraw a lane if has been deleted from iRODS>
  -trd|--include_total_reads   <optionally write the total_reads from bam metadata to the file table in vrtrack>  
  -l|--lock_file               <optional lock file to prevent multiple instances running>
  -h|--help                    <this message>

Update the tracking database from IRODs and the warehouse.

# update all studies listed in the file in the given database
$0 -s my_study_file -d pathogen_abc_track

# update only the given study
$0 -n "My Study" -d pathogen_abc_track

# Lookup all studies listed in the file, but only update the 500 latest files in IRODs
$0 -s my_study_file -d pathogen_abc_track -f 500

# perform the update using 10 processes
$0 -s my_study_file -d pathogen_abc_track -p 10

USAGE

$parallel_processes ||= 1;
$verbose_output ||= 0;
$update_if_changed ||= 0;
$errors_min_run_id ||= 6000;
$dont_use_warehouse ||= 0;
$use_supplier_name ||=0;
$taxon_id ||= 0;
$common_name_required = $taxon_id ? 0 : 1;
$specific_run_id ||=0;
$specific_min_run ||=0;
$no_pending_lanes ||=0;
$override_md5 ||=0;
$withdraw_del ||=0;
$total_reads ||=0;

if(defined($lock_file))
{
  create_lock($lock_file);
}

my $study_names;

if(defined($studyfile))
{
  $study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;
}
else
{
  my @studyname = ($input_study_name);
  $study_names = \@studyname;
}

eval{
  $species_name = $taxon_id ? NCBI::SimpleLookup->new( taxon_id => $taxon_id )->common_name : undef;
};
if ($@) {  
  eval {
	$species_name = $taxon_id ? NCBI::TaxonLookup->new( taxon_id => $taxon_id )->common_name : undef;
  };
  die "Unable to retrieve taxonomic data from NCBI.\n" if ($@);	
}

if($parallel_processes == 1)
{
  my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $db,mode     => 'rw');
  unless ($vrtrack) { die "Can't connect to tracking database: $db \n";}
  if ( $withdraw_del ) {
    foreach my $study (@$study_names) {
	  foreach my $lane ( $vrtrack->get_lanes(project => [$study]) ) {
	    $vrtrack_lanes->{ $lane->name } = $lane->id; 
	  }
	}
  }   
  my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(
    study_names               => $study_names, 
    _vrtrack                  => $vrtrack, 
    number_of_files_to_return => $number_of_files_to_return, 
    verbose_output            => $verbose_output, 
    minimum_run_id            => $errors_min_run_id, 
    update_if_changed         => $update_if_changed,
    dont_use_warehouse        => $dont_use_warehouse,
    common_name_required      => $common_name_required,
    taxon_id                  => $taxon_id,
    species_name              => $species_name,
    use_supplier_name         => $use_supplier_name,
    specific_run_id           => $specific_run_id,
    specific_min_run          => $specific_min_run,
    no_pending_lanes          => $no_pending_lanes,
    override_md5              => $override_md5,
    vrtrack_lanes             => $vrtrack_lanes,
    add_raw_reads             => $total_reads,
  );
  $update_pipeline->update();
}
else
{
  my $pm = new Parallel::ForkManager($parallel_processes); 
  foreach my $study_name (@{$study_names}) {
    $pm->start and next; # do the fork
    my @split_study_names;
    push(@split_study_names, $study_name);
    my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $db,mode     => 'rw');
    unless ($vrtrack) { die "Can't connect to tracking database: $db \n";}
    if ( $withdraw_del ) {
      foreach my $study (@$study_names) {
	    foreach my $lane ( $vrtrack->get_lanes(project => [$study]) ) {
		  $vrtrack_lanes->{ $lane->name } = $lane->id; 
		}
	  }
    }     
    my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(
      study_names               => \@split_study_names, 
      _vrtrack                  => $vrtrack, 
      number_of_files_to_return => $number_of_files_to_return, 
      verbose_output            => $verbose_output, 
      minimum_run_id            => $errors_min_run_id, 
      update_if_changed         => $update_if_changed,
      dont_use_warehouse        => $dont_use_warehouse,
      common_name_required      => $common_name_required,
      taxon_id                  => $taxon_id,
      species_name              => $species_name,
      use_supplier_name         => $use_supplier_name,
      specific_run_id           => $specific_run_id,
      specific_min_run          => $specific_min_run,
      no_pending_lanes          => $no_pending_lanes,
      override_md5              => $override_md5,
      vrtrack_lanes             => $vrtrack_lanes,
      add_raw_reads             => $total_reads,
    );
    $update_pipeline->update();
    $pm->finish; # do the exit in the child process
  }
  $pm->wait_all_children;
}

if(defined($lock_file))
{
  remove_lock($lock_file);
}


# Taken from vr-codebase/scripts/run-pipeline
sub create_lock
{
    my ($lock) = @_;
    if ( !$lock ) { return; } # the locking not requested

    if ( -e $lock )
    {
        # Find out the PID of the running pipeline
        my ($pid) = `cat $lock` || '';
        chomp($pid);
        if ( !($pid=~/^\d+$/) ) { print(qq[Broken lock file $lock? Expected number, found "$pid".\n]); }

        # Is it still running? (Will work only when both are running on the same host.)
        my ($running) = `ps h $pid`;
        if ( $running ) { die "Another process already running: $pid\n"; }
    }

    open(my $fh,'>',$lock) or die "Couldnt open lock file for writing";
    print $fh $$ . "\n";
    close($fh);

    return;
}

sub remove_lock
{
    my ($lock) = @_;
    if ( $lock && -e $lock ) { unlink($lock); }
    return;
}
