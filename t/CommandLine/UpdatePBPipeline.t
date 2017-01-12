#!/usr/bin/env perl
use Moose;
use Data::Dumper;
use File::Slurp;
use File::Path qw( remove_tree);
use Cwd;
use Test::MockObject;

BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }
with 'TestHelper';

BEGIN {
    use Test::Most;
    use VertRes::Utils::VRTrackFactory;
    use VRTrack::VRTrack;
    use_ok('UpdatePipeline::CommandLine::UpdatePBPipeline');
    
    my $irods_sample = Test::MockObject->new();
    $irods_sample->fake_module( 'IRODS::Sample', test => sub{1} );
    $irods_sample->fake_new( 'IRODS::Sample' );
    $irods_sample->mock('file_locations', sub{ ['/path/to/data.0.bas','/another_path/to/data.1.bas'] });
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {md5 => 'abcefg12345667', run => 'run123', well => 'A02'} });

    $ENV{VRTRACK_RW_USER} = 'root';
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = Warehouse::Database->new( settings => $database_settings->{warehouse} )->connect;
delete_test_data($dbh);

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_vrtrack_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'PBBacteria' );


$dbh->do(
    'insert into current_studies  (name,internal_id,accession_number,is_current) values("ABC_study",1111,"EFG123",1)');
$dbh->do(
'insert into current_aliquots (sample_internal_id,receptacle_internal_id,study_internal_id,receptacle_type,is_current) values(2222,3333,1111,"pac_bio_library_tube",1)'
);
$dbh->do(
'insert into current_samples (name,accession_number,common_name, supplier_name,internal_id,is_current) values("PB sample","HIJ456","PBBacteria","Sample supplier name",2222,1)'
);
$dbh->do('insert into current_pac_bio_library_tubes (name,internal_id,is_current) values("PB Library name",3333,1)');



my $script_name = 'UpdatePipeline::CommandLine::UpdatePBPipeline';
my $cwd = getcwd();

local $ENV{PATH} = "$ENV{PATH}:./bin";

# help text
mock_execute_script( $script_name, ['-h']);

## single study
#mock_execute_script( $script_name, ['-e test -d vrtrack_test -n ABC_study']);
#is("run123_A02",         $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_lane where name like "run123_A02"')->[0],'Lane name added');
#is("PB Library name",    $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_library where name like "PB Library name"')->[0],'Library name added');
#is("PB sample",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_sample where name like "PB sample"')->[0],'Sample name added');
#is("ABC_study",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_project where name like "ABC_study"')->[0],'Project name added');
#is("PB sample",          $vrtrack->{_dbh}->selectrow_arrayref('select name from individual where name like "PB sample"')->[0],'Individual name added');
#is("/path/to/data.0.bas",$vrtrack->{_dbh}->selectrow_arrayref('select name from file where name like "/path/to/data.0.bas"')->[0],'File name added');
#is("/another_path/to/data.1.bas",$vrtrack->{_dbh}->selectrow_arrayref('select name from file where name like "/another_path/to/data.1.bas"')->[0],'File name2  added');
#delete_inserted_vrtrack_test_data($vrtrack);

# file of studies
#mock_execute_script( $script_name, ['-e test -d vrtrack_test -s t/data/file_of_studies']);
#is("run123_A02",         $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_lane where name like "run123_A02"')->[0],'Lane name added file_of_studies');
#is("PB Library name",    $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_library where name like "PB Library name"')->[0],'Library name added file_of_studies');
#is("PB sample",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_sample where name like "PB sample"')->[0],'Sample name added file_of_studies');
#is("ABC_study",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_project where name like "ABC_study"')->[0],'Project name added file_of_studies');
#is("PB sample",          $vrtrack->{_dbh}->selectrow_arrayref('select name from individual where name like "PB sample"')->[0],'Individual name added file_of_studies');
#is("/path/to/data.0.bas",$vrtrack->{_dbh}->selectrow_arrayref('select name from file where name like "/path/to/data.0.bas"')->[0],'File name added file_of_studies');
#is("/another_path/to/data.1.bas",$vrtrack->{_dbh}->selectrow_arrayref('select name from file where name like "/another_path/to/data.1.bas"')->[0],'File name2  added file_of_studies');
delete_inserted_vrtrack_test_data($vrtrack);


delete_test_data($dbh);
delete_vrtrack_test_data($vrtrack);
done_testing();

sub delete_test_data {
    my $vrtrack = shift;
    $dbh->do('delete from current_studies where name="ABC_study"');
    $dbh->do('delete from current_aliquots where sample_internal_id=2222');
    $dbh->do('delete from current_samples where name="PB sample"');
    $dbh->do('delete from current_pac_bio_library_tubes where name="PB Library name"');
}

sub delete_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from species where name="PBBacteria"');
  delete_inserted_vrtrack_test_data($vrtrack);
}

sub delete_inserted_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="ABC_study"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("PB sample")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("PB sample")');
  $vrtrack->{_dbh}->do('delete from library where name in ("PB Library name")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("run123_A02")');
  $vrtrack->{_dbh}->do('delete from file where name in ("/path/to/data.0.bas","/another_path/to/data.1.bas")');
}