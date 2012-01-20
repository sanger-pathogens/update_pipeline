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

my ( $studyfile, $help, $database );

GetOptions(
    'p|studies=s'  => \$studyfile,
    'd|database=s' => \$database,
    'h|help'       => \$help,
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
    Usage: $0   
                --studies   <study name or file of SequenceScape study names>
                [--database <vrtrack database name>]
                --help      <this message>

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
my $pipeline_report  = $validate_pipeline->report();

print "\nTotal files in IRODS = ".$pipeline_report->{total_files_in_irods}."\n";

print "\n\nLanes needing action\n";

if($validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking})
{
  print "\n\nWrong sample assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_sample_name_in_tracking}});
}

if($validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking})
{
  print "\n\nWrong Study assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_study_name_in_tracking}});
}

if($validate_pipeline->inconsistent_files->{inconsistent_library_name_in_tracking})
{
  print "\n\nWrong Library assosicated with lane.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_library_name_in_tracking}});
}


if($validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking})
{
  print "\n\nTotal reads are inconsistent. This is a symptom of multiple different critical errors in the pipelines.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{inconsistent_number_of_reads_in_tracking}});
}


if($validate_pipeline->inconsistent_files->{files_missing_from_tracking})
{
  print "\n\nFiles in IRODS but missing from Tracking Database.\n";
  print join("\n", @{$validate_pipeline->inconsistent_files->{files_missing_from_tracking}});
}


if($validate_pipeline->inconsistent_files->{irods_missing_sample_name} ||
  $validate_pipeline->inconsistent_files->{irods_missing_study_name}||
  $validate_pipeline->inconsistent_files->{irods_missing_library_name} ||
  $validate_pipeline->inconsistent_files->{irods_missing_total_reads}  )
{
  print "\n\nData missing in IRODS. Contact NPG\n";
  print( join("\n", @{$validate_pipeline->inconsistent_files->{irods_missing_sample_name}})) if(defined $validate_pipeline->inconsistent_files->{irods_missing_sample_name} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{irods_missing_study_name}})) if(defined $validate_pipeline->inconsistent_files->{irods_missing_study_name} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{irods_missing_library_name}})) if(defined $validate_pipeline->inconsistent_files->{irods_missing_library_name} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{irods_missing_total_reads}})) if(defined $validate_pipeline->inconsistent_files->{irods_missing_total_reads} );
}

if($validate_pipeline->inconsistent_files->{missing_sample_name_in_tracking} ||
  $validate_pipeline->inconsistent_files->{missing_study_name_in_tracking}||
  $validate_pipeline->inconsistent_files->{missing_library_name_in_tracking} ||
  $validate_pipeline->inconsistent_files->{missing_total_reads_in_tracking}  )
{
  print "\n\nData available in IRODS but missing in our Tracking.\n";
  print( join("\n", @{$validate_pipeline->inconsistent_files->{missing_sample_name_in_tracking}})) if(defined $validate_pipeline->inconsistent_files->{missing_sample_name_in_tracking} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{missing_study_name_in_tracking}})) if(defined $validate_pipeline->inconsistent_files->{missing_study_name_in_tracking} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{missing_library_name_in_tracking}})) if(defined $validate_pipeline->inconsistent_files->{missing_library_name_in_tracking} );
  print( join("\n", @{$validate_pipeline->inconsistent_files->{missing_total_reads_in_tracking}})) if(defined $validate_pipeline->inconsistent_files->{missing_total_reads_in_tracking} );
}


