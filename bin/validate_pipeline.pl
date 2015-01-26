#!/usr/bin/env perl

package UpdatePipeline::Main::UpdatePipelineFromSpreadsheet;

# ABSTRACT: validate pipeline 
# PODNAME: validate_pipeline

=head1 SYNOPSIS

Validates the data in a pipeline

=cut
BEGIN { unshift(@INC, './lib') }
BEGIN { unshift(@INC, '../lib') }
use strict;
use warnings;
no warnings 'uninitialized';
use POSIX;
use Getopt::Long;
use VRTrack::VRTrack;
use VertRes::Utils::VRTrackFactory;

use UpdatePipeline::Validate;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $database, $read_count_consistency_check_requested, $no_pending_lanes,$specific_min_run, $file_type);

GetOptions(
    'p|studies=s'      => \$studyfile,
    'd|database=s'     => \$database,
    'c|checkreadcount' => \$read_count_consistency_check_requested,
    'min|specific_min_run=i'  => \$specific_min_run,
    'nop|no_pending_lanes' => \$no_pending_lanes,
    't|file_type=s'    => \$file_type,
    'h|help'           => \$help,
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
    Usage: $0   
                --studies               <study name or file of SequenceScape study names>
                [--database             <vrtrack database name>]
                --checkreadcount        <activate read count consistency evaluation (IO intensive)>
                -nop|--no_pending_lanes <optionally filter out lanes whose npg QC status is pending>
                --file_type             <cram or bam, defaults to bam>
                --specific_min_run      <dont check lanes below this run id (default 10000)>
                --help                  <this message>

Check to see if the pipeline is valid compared to the data stored in IRODS

USAGE

$file_type ||= 'bam';
$specific_min_run ||=10000;

my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(
    database => $db,
    mode     => 'rw'
);

unless ($vrtrack) {
    die "Can't connect to tracking database: $db \n";
}

my @study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;

my $validate_pipeline = UpdatePipeline::Validate->new(study_names => @study_names, _vrtrack => $vrtrack, file_type => $file_type,  specific_min_run   => $specific_min_run,);

if ($read_count_consistency_check_requested) 
{
    $validate_pipeline->request_for_read_count_consistency_evaluation(1);
}

$validate_pipeline->no_pending_lanes(1) if $no_pending_lanes;

my $pipeline_report  = $validate_pipeline->report();
my $problematic_lanes = 0;


if(
    (! defined($validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking})) && 
    (! defined($validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking})) && 
    (! defined($validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking})) && 
    (! defined($validate_pipeline->inconsistent_files->{files_missing_from_tracking})) && 
    (! defined($validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}))
  )
  {
    # No errors to report
    exit(0);
  }

print "\n\nProblematic lanes\n";

if($validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking} && @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}} > 0)
{
  print "\n\nCritical: Wrong sample assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}});
  $problematic_lanes += @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}};
}

if($validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking} && @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}} > 0)
{
  print "\n\nCritical: Total reads are inconsistent. This is a symptom of multiple different critical errors in the pipelines.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}});
  $problematic_lanes += @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}};
}

if($validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking} &&  @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}} > 0 )
{
  print "\n\nLow Priority: Wrong Study assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}});
  $problematic_lanes += @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}};
}


if($validate_pipeline->inconsistent_files->{files_missing_from_tracking} && @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}} > 0)
{
  print "\n\nFiles in IRODS but missing from Tracking Database.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}});
  $problematic_lanes += @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}};
}


if($validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem} && @{$validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}} > 0)
{
  print "\n\nTotal read count in IRODS differs from the total read count on VRTrack's file-system.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}});
  $problematic_lanes += @{$validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}};
}

print "\n\nHealth check complete\n";
print $problematic_lanes ? $problematic_lanes." problematic lanes found.\n":"No errors found.\n";
