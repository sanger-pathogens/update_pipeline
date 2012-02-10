#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 1;
    use_ok('UpdatePipeline::VRTrack::Sample');
    use UpdatePipeline::VRTrack::Project;
    use VRTrack::VRTrack;
}


my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', _vrtrack => $vrtrack)->vr_project();

ok my $sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject), 'initialise a sample';
ok my $vr_sample = $sample->vr_sample(), 'create a vr sample';
isa_ok $vr_sample, "VRTrack::Sample";
isa_ok $vr_sample->individual(), "VRTrack::Individual";


# check that a species has been created and is accessible


#ok my $study = UpdatePipeline::VRTrack::Study->new(accession => 'Accession1234', _vr_project => $vproject), 'initialise for the first time';
#ok my $vr_study = $study->vr_study(), 'create a vr study';
#isa_ok $vr_study , "VRTrack::Study";
#is_deeply $vproject->study('Accession1234'), $vr_study, 'study linked with project';
#
#ok my $study_find_again = UpdatePipeline::VRTrack::Study->new(accession => 'Accession1234', _vr_project => $vproject), 'find it again';
#ok my $vr_study2 = $study_find_again->vr_study(), 'find a vr study';
#isa_ok $vr_study2 , "VRTrack::Study";
#is_deeply $vr_study2->{row_id}, $vr_study->{row_id}, 'same row returned rather than creating it twice';
#
#ok $vrtrack->{_dbh}->do('delete from project where name="My project"'), 'cleanup project';
#ok $vrtrack->{_dbh}->do('delete from study where acc="Accession1234"'), 'cleanup study';
#
#
#
#
#
#
#my $vr_sample = $sample->vr_sample();
#