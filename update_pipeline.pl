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
use Parallel::ForkManager;

use UpdatePipeline::UpdateAllMetaData;
use UpdatePipeline::Studies;

my ( $studyfile, $help, $number_of_files_to_return, $parallel_processes, $verbose_output, $database );

GetOptions(
    's|studies=s'              => \$studyfile,
    'd|database=s'             => \$database,
    'f|max_files_to_return=s'  => \$number_of_files_to_return,
    'p|parallel_processes=s'   => \$parallel_processes,
    'v|verbose'                => \$verbose_output,
    'h|help'                   => \$help,
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
Usage: $0   
  -s|--studies             <file of study names>
  -d|--database            <vrtrack database name>
  -f|--max_files_to_return <optional limit on num of file to check per process>
  -p|--parallel_processes  <optional number of processes to run in parallel, defaults to 1>
  -v|--verbose             <print out debugging information>
  -h|--help                <this message>

Update the tracking database from IRODs and the warehouse

USAGE

$parallel_processes ||= 1;
$verbose_output ||= 0;
my $study_names = UpdatePipeline::Studies->new(filename => $studyfile)->study_names;

if($parallel_processes == 1)
{
  my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(database => $db,mode     => 'rw');
  unless ($vrtrack) { die "Can't connect to tracking database: $db \n";}
  my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => $study_names, _vrtrack => $vrtrack, number_of_files_to_return =>$number_of_files_to_return, verbose_output => $verbose_output );
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
    my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(study_names => \@split_study_names, _vrtrack => $vrtrack, number_of_files_to_return =>$number_of_files_to_return, verbose_output => $verbose_output );
    $update_pipeline->update();
    $pm->finish; # do the exit in the child process
  }
  $pm->wait_all_children;
}



