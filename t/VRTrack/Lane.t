#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 10;
    use_ok('UpdatePipeline::VRTrack::Lane');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack)->vr_project();
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();

# valid lane creation
ok my $lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6', ,_vrtrack => $vrtrack,_vr_library => $vr_library), 'initialise valid lane';
ok my $vr_lane = $lane->vr_lane(), 'build lane';
isa_ok $vr_lane, "VRTrack::Lane";
is_deeply $vr_lane->library_id, $vr_library->id, 'library matches up';

# find previously created lane
ok my $vr_lane2 = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6' ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane(), 'find existing lane';
isa_ok $vr_lane2, "VRTrack::Lane";
is_deeply $vr_lane2, $vr_lane, 'return previously created lane instead of making a new one';

# update the library
my $vr_library3 = UpdatePipeline::VRTrack::Library->new(name => 'Another name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();
ok my $vr_lane3 = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6' ,_vrtrack => $vrtrack,_vr_library => $vr_library3)->vr_lane(), 'initialise update library';
is_deeply $vr_lane3->library_id, UpdatePipeline::VRTrack::Library->new(name => 'Another name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library()->id, 'updated library matches';


delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
  $vrtrack->{_dbh}->do('delete from library where name in ("My library name","My library name2","Another name")');
  $vrtrack->{_dbh}->do('delete from seq_centre where name in ("SC","US")');
  $vrtrack->{_dbh}->do('delete from seq_tech where name in ("SLX","NextNextGen")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("1234_5#6")');
}
