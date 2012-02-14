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

use UpdatePipeline::UpdateAllMetaData;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $number_of_files_to_return, $database );

GetOptions(
    's|studies=s'              => \$studyfile,
    'd|database=s'             => \$database,
    'f|max_files_to_return=s'  => \$number_of_files_to_return,
    'h|help'                   => \$help,
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
Usage: $0   
  -s|--studies   <study name or file of SequenceScape study names>
  -d|--database <vrtrack database name>
  -f|--max_files_to_return <optional limit on the number of files to check, sorted in desc order by filename>
  -h|--help      <this message>

Update the tracking database from IRODs and the warehouse

USAGE

my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(
    database => $db,
    mode     => 'rw'
);

unless ($vrtrack) {
    die "Can't connect to tracking database: $db \n";
}

my @study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;
my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => @study_names, _vrtrack => $vrtrack, number_of_files_to_return =>$number_of_files_to_return );
$update_pipeline->update();

