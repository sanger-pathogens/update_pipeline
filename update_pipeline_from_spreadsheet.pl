#!/usr/bin/env perl

=head1 NAME 
Update_pipeline_from_spreadsheet
=head1 SYNOPSIS

It updates a vrtracking database from a spreadsheet. The spreadsheet must be in Excel xls format (the old format).

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
use UpdatePipeline::Spreadsheet;

my ( $help, $verbose_output, $database, $update_if_changed, $files_to_add_directory,$pipeline_base_directory );

GetOptions(
    'd|database=s'              => \$database,
    'v|verbose'                 => \$verbose_output,
    'f|files_to_add_directory=s'  => \$files_to_add_directory,
    'p|pipeline_base_directory=s' => \$pipeline_base_directory,
    'u|update_if_changed'       => \$update_if_changed,
    'h|help'                    => \$help,
);

my $spreadsheet_filename = $ARGV[0];

( ( -e $spreadsheet_filename)  && $database && !$help ) or die <<USAGE;
Usage: $0 [options] spreadsheet.xls
  -d|--database                <vrtrack database name>
  -v|--verbose                 <print out debugging information>
  -f|--files_to_add_directory  <base directory containing files to add to the pipeline>
  -p|--pipeline_base_directory <required if -f provided, path to sequencing pipeline root directory>
  -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>

  -h|--help                    <this message>

# update the database only
$0 -d pathogen_abc_track spreadsheet.xls

# update the database and copy the sequencing files
$0 -d pathogen_abc_track -f /path/to/incoming/sequencing_files -p /lustre/scratch10x/xxx/seq-pipelines spreadsheet.xls

USAGE

$verbose_output     ||= 0;
$update_if_changed  ||= 0;

my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $database, mode     => 'rw');
unless ($vrtrack) { die "Can't connect to tracking database: $database \n";}


my $spreadsheet = UpdatePipeline::Spreadsheet->new(
  filename             => $spreadsheet_filename,
  dont_use_warehouse   => 1,
  common_name_required => 0,
  _vrtrack             => $vrtrack,
  study_names          => [],
  files_base_directory => $files_to_add_directory,
  pipeline_base_directory => $pipeline_base_directory,
);
$spreadsheet->update();
$spreadsheet->import_sequencing_files_to_pipeline() if(defined($files_to_add_directory));
