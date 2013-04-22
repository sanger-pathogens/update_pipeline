#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 15;
    use_ok('UpdatePipeline::Validate');
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::Validate;
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
    use UpdatePipeline::VRTrack::Lane;
    use UpdatePipeline::VRTrack::File;
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::VRTrack::Study;
    use UpdatePipeline::Exceptions;
}

#create a vrtrack object
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});

#make sure that there is no leftover test data in the test database
delete_test_data($vrtrack);

VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
my $vstudy = UpdatePipeline::VRTrack::Study->new(accession => 'EFG456',_vr_project => $vproject)->vr_study();
$vproject->update;
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',accession => "ABC123", _vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123,fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();
my $vr_lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane)->vr_file();
my $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_5#6',_vrtrack => $vrtrack)->lane_attributes;
my @studies = ('EFG456');

#############################################
#Core tests for UpdatePipeline::Validate.pm 
#############################################
my $validator = UpdatePipeline::Validate->new(study_names => \@studies, _vrtrack => $vrtrack);
isa_ok( $validator, 'UpdatePipeline::Validate' );
can_ok($validator, '_new_lane_changed_too_recently_to_compare');

#last change date new lane >=48
$lane_metadata->{'hours_since_lane_changed'} = 120;
ok( $validator->_new_lane_changed_too_recently_to_compare( {lane_metadata => $lane_metadata, hour_threshold => 48} ) == 0, 
    'handling of new lane with lane_changed >= 48h from now'
  ); 

#last change date new lane < 48hours
$lane_metadata->{'hours_since_lane_changed'} = 17;
ok( $validator->_new_lane_changed_too_recently_to_compare( {lane_metadata => $lane_metadata, hour_threshold => 48} ) == 1, 
    'Handling of new lane with lane_changed < 48h from now'
  ); 

#a lane with processed flag not 0
$lane_metadata->{'lane_processed'} = 1; 
$lane_metadata->{'hours_since_lane_changed'} = 17;
ok( $validator->_new_lane_changed_too_recently_to_compare( {lane_metadata => $lane_metadata, hour_threshold => 48} ) == 0, 
    'A processed lane should return 0 no matter what the lane_changed value is'
  ); 

#Negative values
$lane_metadata->{'lane_processed'} = 0; 
$lane_metadata->{'hours_since_lane_changed'} = -5;
ok( $validator->_new_lane_changed_too_recently_to_compare( {lane_metadata => $lane_metadata, hour_threshold => 48} ) == 1,
    'Negative timediff values should return 1'
  );

#just creating 
my $file_meta_data_which_doesnt_need_changing = UpdatePipeline::FileMetaData->new(
  study_name              => 'DUMMY',
  file_md5                => 'DUMMY',
  file_name               => 'DUMMY.bam',
  file_name_without_extension  => 'DUMMY',
  library_name            => 'DUMMY',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'DUMMY',
  sample_accession_number => "DUMMY",
  study_accession_number  => "DUMMY",
  study_ssid              => 1234,
  sample_common_name      => "SomeDUMMYBacteria",
);

$lane_metadata->{'lane_processed'} = 0; 
$lane_metadata->{'hours_since_lane_changed'} = 17;
$validator->_config_settings->{'minimum_passed_hours_before_comparing_new_lanes_to_irods'} = 48;
is (undef, $validator->_compare_file_metadata_with_vrtrack_lane_metadata($file_meta_data_which_doesnt_need_changing, $lane_metadata),
    'Testing _compare_file_metadata_with_vrtrack_lane_metadata() using a new lane that has a too recent lane_changed date.'
   );

# file in irods but not in tracking database
my $file_in_irods_metadata = UpdatePipeline::FileMetaData->new(

    'study_name'                       => 'My project',
    'study_accession_number'           => 'EFG456',
    'file_md5'                         => 'DUMMY',
    'file_type'                        => 'bam',
    'file_name'                        => '12345_6#7.bam',
    'file_name_without_extension'      => '12345_6#7',
    'library_name'                     => 'My library name',
    'library_ssid'                     => 123,
    'total_reads'                      => 1000000,
    'sample_name'                      => 'My name',
    'sample_accession_number'          => 'ABC123',
    'sample_common_name'               => 'SomeBacteria',
    'lane_is_paired_read'              => 1,
    'lane_manual_qc'                   => 'pending',
    'study_ssid'                       => 1234,
    'id_run'                           => 12345,

    );

# get report
$validator->_files_metadata([$file_in_irods_metadata]);
my $report = $validator->report;
ok( defined $report, 'got report');
ok(defined($report) && $report->{total_files_in_irods} == 1, 'irods file found');
ok(defined($report) && $report->{files_missing_from_tracking} == 1, 'irods file missing from tracking');
ok(!defined($validator->inconsistent_files->{files_missing_from_tracking}), 'missing irods file skipped (qc pending)');

# set to list missing lanes regardless of qc status
$validator->list_all_missing_lanes(1);
$validator->clear_report;
$report = $validator->report;
ok(($validator->inconsistent_files->{files_missing_from_tracking} && @{$validator->inconsistent_files->{files_missing_from_tracking}} == 1), 'missing irods file listed (list all + qc pending)');

# reset list all missing lanes flag
$validator->list_all_missing_lanes(0);
$validator->clear_report;
$report = $validator->report;
ok(!defined($validator->inconsistent_files->{files_missing_from_tracking}), 'confirm list_all_missing_lanes flag reset');

# set irods bam qc to passed and get new report
$file_in_irods_metadata->lane_manual_qc('pass');
$validator->_files_metadata([$file_in_irods_metadata]);
$validator->clear_report;
$report = $validator->report;
ok(($validator->inconsistent_files->{files_missing_from_tracking} && @{$validator->inconsistent_files->{files_missing_from_tracking}} == 1), 'missing irods file listed (qc passed)');


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
  $vrtrack->{_dbh}->do('delete from lane where name in ("1234_5#6","9876_5#4")');
  $vrtrack->{_dbh}->do('delete from file where name in ("myfile.bam","myfile2.bam")');
  $vrtrack->{_dbh}->do('delete from study where acc in ("EFG456")');
}
