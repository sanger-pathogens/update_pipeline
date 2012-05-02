#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::MockObject;
use VRTrack::VRTrack;


BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most;
  use_ok('UpdatePipeline::Spreadsheet');
  
  my $ncbi_taxon_lookup = Test::MockObject->new();
  $ncbi_taxon_lookup->fake_module( 'NCBI::TaxonLookup', test => sub{1} );
  $ncbi_taxon_lookup->fake_new( 'NCBI::TaxonLookup' );
  $ncbi_taxon_lookup->mock('common_name', sub{ 'SomeCommonName' });
}

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
$vrtrack->{_dbh}->do("INSERT INTO `project` (`project_id`,`ssid`,`name`, `hierarchy_name`,`study_id`,`changed`,`latest`) VALUES	(1,123,'My Study Name','My_Study_Name',1,NOW(),1)");
$vrtrack->{_dbh}->do("INSERT INTO `sample`  (`sample_id`, `ssid`,`name`, `hierarchy_name`,`changed`,`latest`) VALUES	(1,456,'2','2',NOW(),1)");
$vrtrack->{_dbh}->do("INSERT INTO `library` (`library_id`,`ssid`,`name`, `hierarchy_name`,`changed`,`latest`) VALUES	(1,789,'ABC45678','ABC45678',NOW(),1)");

ok my $spreadsheet = UpdatePipeline::Spreadsheet->new(
  filename    => 't/data/external_data_example.xls',
  _vrtrack    => $vrtrack,
  study_names => [],
  dont_use_warehouse => 1,
  common_name_required => 0
), 'initialise spreadsheet driver class';
ok $spreadsheet->_files_metadata, 'generate the files metadata';

is $spreadsheet->_files_metadata->[0]->file_name,'myfile.fastq.gz', 'filename returned correctly';

is $spreadsheet->_files_metadata->[0]->study_ssid,   123, 'existing study ssid reused';
is $spreadsheet->_files_metadata->[0]->sample_ssid,  457, 'next sample ssid';
is $spreadsheet->_files_metadata->[0]->library_ssid, 790, 'next library ssid used';

is $spreadsheet->_files_metadata->[1]->study_ssid,   123, 'existing study ssid reused';
is $spreadsheet->_files_metadata->[1]->sample_ssid,  456, 'existing sample ssid';
is $spreadsheet->_files_metadata->[1]->library_ssid, 791, 'existing library ssid used';

is $spreadsheet->_files_metadata->[2]->study_ssid,   123, 'existing study ssid reused';
is $spreadsheet->_files_metadata->[2]->sample_ssid,  458, 'increment twice sample ssid';
is $spreadsheet->_files_metadata->[2]->library_ssid, 789, 'increment twice library ssid used';


# put in some tests here to check the state
ok $spreadsheet->update();



done_testing();
delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My Study Name"');
  $vrtrack->{_dbh}->do('delete from sample');
  $vrtrack->{_dbh}->do('delete from library');
}
