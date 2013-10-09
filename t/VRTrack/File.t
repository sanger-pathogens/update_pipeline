#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 13;
    use_ok('UpdatePipeline::VRTrack::File');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
    use UpdatePipeline::VRTrack::Lane;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack)->vr_project();
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();
my $vr_lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6', total_reads => 1000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();


# create a File object
ok my $file = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane), 'initialise file';
ok my $vr_file = $file->vr_file(), 'build vr file';
isa_ok $vr_file, "VRTrack::File";
is_deeply $vr_file->lane_id, $vr_lane->id, 'lanes matches up';

# return previously created file if it exists
ok my $vr_file2 = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane)->vr_file(), 'find preexisting file';
is_deeply $vr_file, $vr_file2, 'file found rather than created';

# dont create a file if the lane is already processed for import
my $vr_lane_imported = UpdatePipeline::VRTrack::Lane->new(name  => '9876_5#4', total_reads => 1000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
$vr_lane_imported->is_processed('import', 1);
$vr_lane_imported->update;
is undef, UpdatePipeline::VRTrack::File->new(name => 'myfile2.bam',md5 => 'abc1231343432432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane_imported)->vr_file(), 'find preexisting file which has a previously imported lane';

# if MD5 changes then flag up an error
ok my $vrfile_4 = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'new_md5_for_file',_vrtrack => $vrtrack,_vr_lane => $vr_lane), 'find file with different md5';
throws_ok { $vrfile_4->vr_file() } qr/MD5 changed from/, 'Throw an exception if the MD5 of a file has changed';

# if MD5 changes, but the override is set then update md5
ok my $file5 = UpdatePipeline::VRTrack::File->new(name => 'myfile.bam',md5 => 'cde3456675232432432',_vrtrack => $vrtrack,_vr_lane => $vr_lane, override_md5 => 1), 'find file with different md5';
ok my $vr_file5 = $file5->vr_file(), 'build vr file';
is $vr_file5->md5, 'cde3456675232432432', 'MD5 has been successfully updated';

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
}
