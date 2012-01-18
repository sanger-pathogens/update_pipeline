#!/usr/bin/env perl

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 CONTACT
=head1 METHODS

=cut


use strict;
use warnings;
no warnings 'uninitialized';
use POSIX;
use Getopt::Long;
#use Sfind::Sfind;
use VRTrack::VRTrack;
use VRTrack::Lane;
use VRTrack::Library;
use VRTrack::Multiplex_pool;
use VRTrack::Library_Multiplex_pool;
use VertRes::Utils::VRTrackFactory;

my ( $studyfile, $help, $database );

GetOptions(
    'p|studies=s'  => \$studyfile,
    'd|database=s' => \$database,
    'h|help'       => \$help,
);

my %info_for_spp = (
    'Viruses'     => 'pathogen_virus_track',
    'Prokaryotes' => 'pathogen_prok_track',
    'Eukaryotes'  => 'pathogen_euk_track',
    'Helminths'   => 'pathogen_helminth_track',
    'Prokaryotes_Test' => 'pathogen_prok_track_test'
);

my $db = $database ;

( $studyfile &&  $db && !$help ) or die <<USAGE;
    Usage: $0   
                --studies   <study name or file of SequenceScape study names>
                [--database <vrtrack database name override>]
                --help      <this message>

Updates pathtrack databases from the warehouse.

USAGE

# npg_qc_status => can only get from warehouse
# is paired => take from the BAM header from irods @RG tag, if PI is greater than 0, its paired ended
# sample common name => can only get from warehouse
# sample accession number => can get sample accession from bam header

# study ssid?
# sample ssid?


my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate(
    database => $db,
    mode     => 'rw'
);

unless ($vrtrack) {
    die "Can't connect to tracking database: $db \n";
}

my $studies;
$studies = get_study_names($studyfile);

my %vprojects;

for my $study_name (@{$studies})
{
  my $bam_file_locations;
  $bam_file_locations = lookup_bam_files_for_study($study_name);
  
  for my $bam_file_location (@{$bam_file_locations})
  {
    my $bam_metadata;
    $bam_metadata = get_irods_metadata_for_bam($bam_file_location);

    # look up the project and reuse an existing object if its been seen before
    my $vproject;
    if($vprojects{$bam_metadata->{study}})
    {
      $vproject = $vprojects{$bam_metadata->{study}};
    }
    else
    {
      $vproject = get_project($bam_metadata->{study}, $vrtrack);
      get_study($bam_metadata->{study_accession_number}, $vproject);
      $vprojects{$bam_metadata->{study}} = $vproject;
    }
    
    my $vsample  = get_sample($bam_metadata->{sample}, $vproject,$vrtrack);
    my $vlibrary = get_library($bam_metadata->{library}, $bam_metadata->{library_id}, $vsample,$vrtrack);
    my $vlane    = get_lane($bam_metadata->{id_run}, $bam_metadata->{lane}, $bam_metadata->{tag_index},$bam_metadata->{total_reads},  $vlibrary,$vrtrack);
    my $vfile    = get_file($vlane, $bam_metadata->{md5}, $vrtrack);
  }
}

sub get_file
{
  my ($vlane, $md5, $vrtrack) = @_;
  # TODO make sure you dont repeatedly download bam files
  my $vfile;
  return $vfile if ($vlane->is_processed( 'import'));

  $vfile = $vlane->get_file_by_name($vlane->name.'.bam');
  unless(defined($vfile))
  {
    $vfile = $vlane->add_file($vlane->name.'.bam');
    $vfile->md5($md5);
    $vfile->type(4);
    $vfile->update;
  }
  return $vfile;
}

sub get_lane
{
  my ($id_run, $lane, $tag_index, $total_reads, $vlibrary, $vrtrack) = @_;
  
  my $lane_name = $id_run.'_'.$lane;
  if(defined($tag_index))
  {
    $lane_name = $id_run.'_'.$lane.'#'.$tag_index;
  }
  
  my $vlane = VRTrack::Lane->new_by_name( $vrtrack, $lane_name);
  unless(defined($vlane))
  {
    $vlane = $vlibrary->add_lane($lane_name);
  }
  
  $vlane->raw_reads( $total_reads );
  $vlane->hierarchy_name( $lane_name );
  $vlane->update;
  
  return $vlane;
}



sub get_library
{
  my ($library_name, $library_id, $vsample, $vrtrack) = @_;
  my $vlibrary = VRTrack::Library->new_by_name( $vrtrack, $library_name);
  unless(defined($vlibrary))
  {
    $vlibrary = $vsample->add_library($library_name);
  }
  
  my $seq_tech = $vlibrary->seq_tech('SLX');
  unless ($seq_tech) {
        $vlibrary->add_seq_tech('SLX');
  }
  
  return $vlibrary;
}

# we dont use individuals so this is the same as the sample and is a way to link to the species
sub get_individual
{
  my ($sample_name, $vrtrack) = @_;
  my $individual = VRTrack::Individual->new_by_name( $vrtrack, $sample_name );

  my $organism  = get_common_name_from_sample_name($sample_name, $vrtrack);

  if ( not defined $individual ) {
    $individual = VRTrack::Individual->create( $vrtrack, $sample_name);
    $individual->species($organism);
  }
  
}

sub get_common_name_from_sample_name
{
  my ($sample_name, $vrtrack) = @_;
  #my $organism = $sample->common_name();
  #$organism =~ s/^\s+|\s+$//g;    # Remove leading/trailing spaces
  return "INSERT ORGANISM HERE";
}

sub get_sample
{
  my ($sample_name, $vproject,$vrtrack) = @_;
  my $vsample = VRTrack::Sample->new_by_name_project( $vrtrack, $sample_name, $vproject->id );
  unless(defined($vsample))
  {
    $vsample = $vproject->add_sample($sample_name);
  }
  
  get_individual($sample_name, $vrtrack);
  
  return $vsample;
}

sub get_project
{
  my ($study_name,$vrtrack) = @_;
  my $vproject = VRTrack::Project->new_by_name( $vrtrack, $study_name );
  
  unless(defined($vproject))
  {
    $vproject = $vrtrack->add_project($study_name);
  }
  return $vproject;
}

# a study just contains an accession number in this case
sub get_study
{
  my ($study_accession,$vproject) = @_;

  my $vstudy = $vproject->study($study_accession);
  unless ($vstudy) {
    $vstudy = $vproject->add_study($study_accession);
  }
  return $vstudy;
}



sub get_irods_metadata_for_bam {
    my ($filename) = @_;

    my $irods_dir = '/software/irods/icommands/bin/';
    my $command   = $irods_dir . 'imeta ls -d ' . $filename;

    my %file_attribute;
    open( my $irods, "$command |" );

    my $attribute = '';
    while (<$irods>) {
        if (/^attribute: (.+)$/) { $attribute                    = $1; }
        if (/^value: (.+)$/)     { $file_attribute{$attribute} = $1; }
    }
    close $irods;

    return \%file_attribute;
}


sub get_study_names
{
  my ($study_file) = @_;
  my @studies;
  
  if ( -s $study_file ) {
      open( my $STU, "$study_file" ) or die "Can't open $study_file: $!\n";
      while (<$STU>) {
          if ($_) {    #Ignore empty lines
              chomp;
              push( @studies, $_ );
          }
      }
      close $STU;
  }
  return \@studies;
}




