#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 36;
    use_ok('UpdatePipeline::UpdateLaneMetaData');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
    use UpdatePipeline::VRTrack::Lane;
    use UpdatePipeline::VRTrack::File;
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::VRTrack::Study;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
my $vstudy = UpdatePipeline::VRTrack::Study->new(accession => 'EFG456',_vr_project => $vproject)->vr_study();
$vproject->update;
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',accession => "ABC123", _vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123,fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();
my $vr_lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $vr_file = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane)->vr_file();

ok my $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_5#6',_vrtrack => $vrtrack)->lane_attributes, 'create lane metadata object';

#We need these two keys to be present in order to use the 
#UpdatePipeline::Validate class properly
ok exists $$lane_metadata{'lane_processed'},                  'lane_processed key exists';
ok exists $$lane_metadata{'lane_changed'},                    'lane_changed key exists';
ok exists $$lane_metadata{'hours_since_lane_changed'},        'hours_since_lane_changed key exists';

ok my $file_meta_data_which_doesnt_need_changing = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'file meta data which should be the same as the lane metadata';

ok my $update_lane_metadata = UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_meta_data_which_doesnt_need_changing ), 'initialise update metadata with no changes';
is $update_lane_metadata->update_required, 0, 'no update is needed';

ok my $file_metadata_sample_name_with_underscore_nochange = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My_name',
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'file meta data which should be the same as the lane metadata';
is 0, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_sample_name_with_underscore_nochange )->update_required(), 'sample name with underscores should not trigger change';

ok my $file_metadata_with_sample_name_change = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'changed sample name',
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'sample name changed';
throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_with_sample_name_change )->update_required()} qr /myfile/,'update required since sample name changed';

ok my $file_metadata_with_library_name_change = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'new library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'library name changed';
throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_with_library_name_change )->update_required()} qr /myfile/, 'update required since library name changed';

ok my $file_metadata_with_library_ssid_change = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 9999999,
  total_reads             => 100000,
  study_ssid              => 1234,
  sample_name             => 'My name',
  sample_common_name      => "SomeBacteria",
), 'library ssid changed';
is 1, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_with_library_ssid_change )->update_required(), 'update required since library ssid changed';

ok my $file_metadata_with_study_name_change = UpdatePipeline::FileMetaData->new(
  study_name              => 'study name changed',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  study_ssid              => 1234,
  sample_name             => 'My name',
  sample_common_name      => "SomeBacteria",
), 'study name changed';
is 1, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_with_study_name_change )->update_required(), 'update required since study name changed';


# study and sample accession numbers
ok my $file_metadata_study_accession_changed = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "ABC123",
  study_ssid              => 1234,
  study_accession_number  => "study_accession_changed",
  sample_common_name      => "SomeBacteria",
), 'file meta data with a chagned study accession';
is 1, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_study_accession_changed )->update_required(), 'study accession changed';


# study and sample accession numbers
ok my $file_metadata_sample_accession_changed = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "Changed_sample_accession",
  study_accession_number  => "EFG456",
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'file meta data with a changed sample accession';
is 1, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_sample_accession_changed )->update_required(), 'sample accession changed';


# sample common name is changed
ok my $file_metadata_common_name_changed = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  study_ssid              => 1234,
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  sample_common_name      => "CommonNameChanged",
), 'file meta data with a changed sample common name';
throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_common_name_changed )->update_required()} qr /myfile/, 'common name changed';


# npg_qc_status has changed
ok my $file_metadata_manual_qc_status_changed = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  study_ssid              => 1234,
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  sample_common_name      => "SomeBacteria",
  lane_manual_qc          => "failed"
), 'file meta data with changed manual qc status';
is 1, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_manual_qc_status_changed )->update_required(), 'manual qc status changed';


# is paired has changed
ok my $file_metadata_paired_changed = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_name             => 'My name',
  sample_accession_number => "ABC123",
  study_ssid              => 1234,
  study_accession_number  => "EFG456",
  sample_common_name      => "SomeBacteria",
  lane_is_paired_read     => 0
), 'file meta data with changed paired flag';
is 0, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_metadata_paired_changed )->update_required(), 'paired flag changed but we do nothing';


# missing essential data
ok my $file_missing_sample_name = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  study_ssid              => 1234,
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  sample_common_name      => "SomeBacteria",
), 'file meta data missing sample name';

throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_missing_sample_name )->update_required } qr/myfile/, 'missing sample name';


# missing  sample common name
ok my $file_missing_sample_common_name = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 100000,
  sample_accession_number => "ABC123",
  study_ssid              => 1234,
  study_accession_number  => "EFG456",
  sample_name             => 'My name',
), 'file meta data missing sample common name';

throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_missing_sample_common_name )->update_required } qr/My name/, 'missing sample common name';


# Total reads inconsistent but lane hasnt been flagged as imported
ok my $file_total_reads_noproblem = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 20000,
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  sample_name             => 'My name',
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'skip file meta data total reads inconsistent';

is 0, UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_total_reads_noproblem )->update_required  , 'skip Total Reads inconsistent';



# Total reads inconsistent
$lane_metadata->{lane_processed} = 1;
ok my $file_total_reads_problem = UpdatePipeline::FileMetaData->new(
  study_name              => 'My project',
  file_md5                => 'abc1231343432432432',
  file_name               => 'myfile.bam',
  file_name_without_extension  => 'myfile',
  library_name            => 'My library name',
  library_ssid            => 123,
  total_reads             => 20000,
  sample_accession_number => "ABC123",
  study_accession_number  => "EFG456",
  sample_name             => 'My name',
  study_ssid              => 1234,
  sample_common_name      => "SomeBacteria",
), 'file meta data total reads inconsistent';

throws_ok {UpdatePipeline::UpdateLaneMetaData->new(lane_meta_data => $lane_metadata, file_meta_data => $file_total_reads_problem )->update_required } qr/myfile/, 'Total Reads inconsistent';


# lane has been previously imported so ignore file md5 etc...


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
