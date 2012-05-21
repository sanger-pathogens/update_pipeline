#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use VRTrack::VRTrack;
 
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
$vproject->update;


# Manually insert an individual row
$vrtrack->{_dbh}->do(qq[insert into individual (name, hierarchy_name) values ('Some other name','My_name')]);

# the sample should be created okay
ok my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',accession => "ABC123", _vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample(),'sample created okay';
is $vr_sample->individual()->name, 'My name', 'name should be same as sample';
isnt( ($vr_sample->individual()->hierarchy_name), 'My_name', 'hierarchy name can be something different sample');

done_testing();
delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name like "My name%" ');
  $vrtrack->{_dbh}->do('delete from individual where name in ("Some other name")');
  $vrtrack->{_dbh}->do('delete from individual where name like "My name%"');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
}