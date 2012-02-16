#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 20;
    use_ok('UpdatePipeline::VRTrack::Library');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack)->vr_project();
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();

# valid inputs create
ok my $library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample), 'initialise valid creation';
ok my $vr_library = $library->vr_library(), 'build vr library';
isa_ok $vr_library, "VRTrack::Library";
is $vr_library->seq_centre->name, 'SC', 'default sequencing centre';
is $vr_library->seq_tech->name, 'SLX', 'default sequencing technology';
is $vr_library->sample_id, $vr_sample->id, 'sample name picked up correctly';

# library already exists
ok my $library2 = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample), 'initialise valid creation';
ok my $vr_library2 = $library2->vr_library(), 'build vr library';
isa_ok $vr_library2, "VRTrack::Library";
is_deeply $vr_library2, $vr_library, 'previously created library returned';


# library exists but sample has changed
my $vr_sample3 = UpdatePipeline::VRTrack::Sample->new(name => 'Another name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
ok my $library3 = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123, _vrtrack => $vrtrack,_vr_sample  => $vr_sample3), 'initialise valid creation with different sample';
ok my $vr_library3 = $library3->vr_library(), 'build vr library';
isa_ok $vr_library3, "VRTrack::Library";
is $vr_library3->name, $vr_library->name, 'previously created library returned';
is_deeply $vr_library3->sample_id, UpdatePipeline::VRTrack::Sample->new(name => 'Another name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample()->id, 'updated sample id should be returned';

# send in a different sequencing technology and external id not present
ok my $library4 = UpdatePipeline::VRTrack::Library->new(name => 'My library name2', sequencing_technology => 'NextNextGen', sequencing_centre => 'US',  _vrtrack => $vrtrack,_vr_sample  => $vr_sample), 'initialise valid creation';
ok my $vr_library4 = $library4->vr_library(), 'build vr library';
is $vr_library4->seq_centre->name, 'US', 'new sequencing centre';
is $vr_library4->seq_tech->name, 'NextNextGen', 'new sequencing technology';


# TODO
# library exists by ssid but the library name has changed
# delete original library row with ssid??

delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
  $vrtrack->{_dbh}->do('delete from library where name in ("My library name","My library name2")');
  $vrtrack->{_dbh}->do('delete from seq_centre where name in ("SC","US")');
  $vrtrack->{_dbh}->do('delete from seq_tech where name in ("SLX","NextNextGen")');
}
