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
use VertRes::Utils::VRTrackFactory;
use Data::Dumper;

use UpdatePipeline::Validate;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $database, $read_count_consistency_check_requested, $list_all_missing_lanes_requested);

GetOptions(
    'p|studies=s'      => \$studyfile,
    'd|database=s'     => \$database,
    'c|checkreadcount' => \$read_count_consistency_check_requested,
    'l|listallmissing' => \$list_all_missing_lanes_requested,
    'h|help'           => \$help,
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
    Usage: $0   
                --studies          <study name or file of SequenceScape study names>
                [--database        <vrtrack database name>]
                --checkreadcount   <activate read count consistency evaluation (IO intensive)>
                --listallmissing   <list all missing irods lanes with over 10000 reads (ignore iRODS qc status)>
                --help             <this message>

Check to see if the pipeline is valid compared to the data stored in IRODS

USAGE

my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(
    database => $db,
    mode     => 'rw'
);

unless ($vrtrack) {
    die "Can't connect to tracking database: $db \n";
}

my @study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;

my $validate_pipeline = UpdatePipeline::Validate->new(study_names => @study_names, _vrtrack => $vrtrack);

if ($read_count_consistency_check_requested) 
{
    $validate_pipeline->request_for_read_count_consistency_evaluation(1);
}

$validate_pipeline->list_all_missing_lanes(1) if $list_all_missing_lanes_requested;

my $pipeline_report  = $validate_pipeline->report();

print "\n\nProblematic lanes\n";

if($validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking} && @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}} > 0)
{
  print "\n\nCritical: Wrong sample assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}});
}

if($validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking} && @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}} > 0)
{
  print "\n\nCritical: Total reads are inconsistent. This is a symptom of multiple different critical errors in the pipelines.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}});
}

if($validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking} &&  @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}} > 0 )
{
  print "\n\nLow Priority: Wrong Study assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}});
}


if($validate_pipeline->inconsistent_files->{files_missing_from_tracking} && @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}} > 0)
{
  print "\n\nFiles in IRODS but missing from Tracking Database.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}});
}


if($validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem} && @{$validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}} > 0)
{
  print "\n\nTotal read count in IRODS differs from the total read count on VRTrack's file-system.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{read_count_discrepancy_between_irods_and_vrtrack_filesystem}});
}
