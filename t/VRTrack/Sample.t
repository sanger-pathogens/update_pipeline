#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 16;
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
isa_ok $vr_sample->individual->species, "VRTrack::Species";
is $vr_sample->individual->species->name, "SomeBacteria", 'get the species back';

# find a previously created sample
ok my $sample2 = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',_vrtrack => $vrtrack,_vr_project => $vproject), 'initialise a sample';
ok my $vr_sample2 = $sample2->vr_sample(), 'find a vr sample';
isa_ok $vr_sample2, "VRTrack::Sample";
isa_ok $vr_sample2->individual(), "VRTrack::Individual";
isa_ok $vr_sample2->individual->species, "VRTrack::Species";
is $vr_sample2->individual->species->name, "SomeBacteria", 'get the species back';
is_deeply $sample2, $sample, 'return the same row for a sample';
is_deeply $vr_sample2->individual, $vr_sample->individual, 'return the same row for an individual';
is_deeply $vr_sample2->individual->species, $vr_sample->individual->species, 'return the same row for a species';

$vrtrack->{_dbh}->do('delete from project where name="My project"');
$vrtrack->{_dbh}->do('delete from sample where name="My name"');
$vrtrack->{_dbh}->do('delete from individual where name="My name"');
$vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
