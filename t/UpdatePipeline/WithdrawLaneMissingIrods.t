#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 12;
    use_ok('UpdatePipeline::VRTrack::File');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
    use UpdatePipeline::VRTrack::Lane;
    use UpdatePipeline::VRTrack::File;
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::VRTrack::Study;
    use UpdatePipeline::FileMetaData;
    use UpdatePipeline::IRODS;
    use UpdatePipeline::UpdateAllMetaData;
    use IRODS::File;
}

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);

VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
my $vstudy = UpdatePipeline::VRTrack::Study->new(accession => 'EFG456',_vr_project => $vproject)->vr_study();
$vproject->update;
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',accession => "ABC123", _vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123,fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();

#create lanes and hash of lane names / ids for comparison to lanes in irods later
my $vrtrack_lanes;
my $vr_lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane)->vr_file();
ok my $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_5',_vrtrack => $vrtrack)->lane_attributes, 'create first lane metadata object';
$vrtrack_lanes->{ $vr_lane->name } = $vr_lane->id; 
my $vr_lane2 = UpdatePipeline::VRTrack::Lane->new(name  => '1234_6', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file2 = UpdatePipeline::VRTrack::File->new(name => 'myfile2.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane2)->vr_file();
ok $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_6',_vrtrack => $vrtrack)->lane_attributes, 'create second lane metadata object';
$vrtrack_lanes->{ $vr_lane2->name } = $vr_lane2->id; 
my $vr_lane3 = UpdatePipeline::VRTrack::Lane->new(name  => '1234_7', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file3 = UpdatePipeline::VRTrack::File->new(name => 'myfile3.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane3)->vr_file();
ok $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_7',_vrtrack => $vrtrack)->lane_attributes, 'create third lane metadata object';
$vrtrack_lanes->{ $vr_lane3->name } = $vr_lane3->id; 
my $vr_lane4 = UpdatePipeline::VRTrack::Lane->new(name  => '1234_8', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file4 = UpdatePipeline::VRTrack::File->new(name => 'myfile4.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane4)->vr_file();
ok $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_8',_vrtrack => $vrtrack)->lane_attributes, 'create fourth lane metadata object';
$vrtrack_lanes->{ $vr_lane4->name } = $vr_lane4->id; 

my %expected_lanes_not_in_irods = (
    $vr_lane3->name => $vr_lane3->id,
    $vr_lane4->name => $vr_lane4->id
);

#get file metadata for files in irods
my @files_metadata;

ok my $file_meta_data1 = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => '1234_5#33.bam',
  file_name_without_extension  => '1234_5',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'loading metadata for first file';

ok my $file_meta_data2 = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => '1234_6.bam',
  file_name_without_extension  => '1234_6',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "ABC124",
  study_accession_number  => "EFG457",
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'loading metadata for second file';

push (@files_metadata, $file_meta_data1);
push (@files_metadata, $file_meta_data2);

my @studyname = ('EFG456');
ok my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(
    study_names               => \@studyname, 
    _vrtrack                  => $vrtrack, 
    vrtrack_lanes             => $vrtrack_lanes,
    _files_metadata           => \@files_metadata,
), 'running metadata through UpdateAllMetaData';
ok $update_pipeline->update(), 'updating pipeline database';

my $vlane3 = VRTrack::Lane->new_by_name( $vrtrack, $vr_lane3->name );
my $vlane4 = VRTrack::Lane->new_by_name( $vrtrack, $vr_lane4->name );
is $vlane3->is_withdrawn, 1, 'lane '.$vr_lane3->name.' has been withdrawn as expected';
is $vlane4->is_withdrawn, 1, 'lane '.$vr_lane4->name.' has been withdrawn as expected';

#probably unnecessary: double-check lanes are removed which are found in irods and check expected result
for my $file_metadata (@files_metadata) {
    if ( $vrtrack_lanes && $vrtrack_lanes->{$file_metadata->file_name_without_extension} ) {
	    delete $vrtrack_lanes->{$file_metadata->file_name_without_extension};
	}	
}
is_deeply $vrtrack_lanes, \%expected_lanes_not_in_irods, 'double-check: correct lanes missing from irods';

delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("My name")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("My name")');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
  $vrtrack->{_dbh}->do('delete from library where name in ("My library name")');
  $vrtrack->{_dbh}->do('delete from seq_centre where name in ("SC")');
  $vrtrack->{_dbh}->do('delete from seq_tech where name in ("SLX")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("1234_5","1234_6","1234_7","1234_8")');
  $vrtrack->{_dbh}->do('delete from file where name in ("myfile.bam","myfile2.bam","myfile3.bam","myfile4.bam")');
  $vrtrack->{_dbh}->do('delete from study where acc in ("EFG456")');
}
