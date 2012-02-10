#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 9;
    use_ok('UpdatePipeline::VRTrack::Project');
    use VRTrack::VRTrack;
}

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});

ok my $project = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack), 'initialise for the first time';
ok my $vr_project = $project->vr_project(), 'create a vr project';
isa_ok $vr_project , "VRTrack::Project";

ok my $project_find_again = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack), 'find it again';
ok my $vr_project2 = $project_find_again->vr_project(), 'find a vr project';
isa_ok $vr_project2 , "VRTrack::Project";
is $vr_project2->{row_id}, $vr_project->{row_id}, 'same row returned rather than creating it twice';

ok $vrtrack->{_dbh}->do('delete from project where name="My project"'), 'cleanup';
