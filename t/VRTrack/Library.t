#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
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


# an insert size is passed in so save it with the library
ok my $library_insert_size = UpdatePipeline::VRTrack::Library->new(name => 'My library name3', external_id  => 123, fragment_size_from => 250,fragment_size_to => 250,  _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library(), 'create a library with an insert size';
is $library_insert_size->fragment_size_from(), 250, 'fragment size from set to insert size';
is $library_insert_size->fragment_size_to(), 250, 'fragment size from set to insert size';

# If the insert size was previously set, dont change it
ok my $library_exists_update_insert_size = UpdatePipeline::VRTrack::Library->new(name => 'My library name3', external_id  => 123, fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library(), 'find and update a library with an insert size';
is $library_exists_update_insert_size->fragment_size_from(), 250, 'frag size from shouldnt change if previously set';
is $library_exists_update_insert_size->fragment_size_to(), 250, 'frag size to shouldnt change if previously set';

# the fragement size from is smaller than the fragement size to
ok my $fragment_sizes_reversed = UpdatePipeline::VRTrack::Library->new(name => 'My library name4', external_id  => 123, fragment_size_from => 150,fragment_size_to => 50, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library(), 'find and update a library with an insert size';
is $fragment_sizes_reversed->fragment_size_from(), 50, 'frag sizes swapped for from';
is $fragment_sizes_reversed->fragment_size_to(), 150, 'frag sizes swapped for to';


# Library already exists but the fragment size wasnt set, so set it now
ok my $library_exists_with_no_frag_size_set = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123,fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library(), 'initialise valid creation';
is $library_exists_with_no_frag_size_set->fragment_size_from(), 123, 'frag size from set ';
is $library_exists_with_no_frag_size_set->fragment_size_to(), 999, 'frag sizes to set';

# TODO
# library exists by ssid but the library name has changed
# delete original library row with ssid??

delete_test_data($vrtrack);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("My name","Another name")');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
  $vrtrack->{_dbh}->do('delete from library where name in ("My library name","My library name2","My library name3","My library name4")');
  $vrtrack->{_dbh}->do('delete from seq_centre where name in ("SC","US")');
  $vrtrack->{_dbh}->do('delete from seq_tech where name in ("SLX","NextNextGen")');
}
