#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use Test::MockObject;


BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use Pathogens::ConfigSettings;
    use Warehouse::Database;
    use_ok('UpdatePipeline::PB::StudyFilesMetaData');
    
    my $irods_sample = Test::MockObject->new();
    $irods_sample->fake_module( 'IRODS::Sample', test => sub{1} );
    $irods_sample->fake_new( 'IRODS::Sample' );
    $irods_sample->mock('file_locations', sub{ ['/path/to/data.0.bas'] });
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {md5 => 'abcefg12345667', run => 'run123', well => 'A02'} });
    
    
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = Warehouse::Database->new( settings => $database_settings->{warehouse} )->connect;

delete_test_data($dbh);
$dbh->do(
    'insert into current_studies  (name,internal_id,accession_number,is_current) values("ABC study",1111,"EFG123",1)');
$dbh->do(
'insert into current_aliquots (sample_internal_id,receptacle_internal_id,study_internal_id,receptacle_type,is_current) values(2222,3333,1111,"pac_bio_library_tube",1)'
);
$dbh->do(
'insert into current_samples (name,accession_number,common_name, supplier_name,internal_id,is_current) values("ABC sample","HIJ456","Sample common name","Sample supplier name",2222,1)'
);
$dbh->do('insert into current_pac_bio_library_tubes (name,internal_id,is_current) values("Library name",3333,1)');



ok(my $obj = UpdatePipeline::PB::StudyFilesMetaData->new(
    study_name        => 'ABC study',
    dbh               => $dbh
  ),'initialise object with valid study ');

is_deeply([
          bless( {
                   'library_ssid' => '3333',
                   'sample_ssid' => '2222',
                   'library_name' => 'Library name',
                   'study_ssid' => '1111',
                   'supplier_name' => 'Sample supplier name',
                   'sample_common_name' => 'Sample common name',
                   'study_accession_number' => 'EFG123',
                   'study_name' => 'ABC study',
                   'sample_name' => 'ABC sample',
                   'sample_accession_number' => 'HIJ456',
                   'file_location' => '/path/to/data.0.bas',
                   'lane_name' => 'run123_A02',
                   'md5' => 'abcefg12345667'
                 }, 'UpdatePipeline::PB::FileMetaData' )
        ], $obj->files_metadata(),'files found');

ok(my $obj_doesnt_exist = UpdatePipeline::PB::StudyFilesMetaData->new(
    study_name        => 'study that doesnt exist',
    dbh               => $dbh
  ),'initialise object with study that doesnt exist');
is_deeply([],$obj_doesnt_exist->files_metadata, 'Study that doesnt exist shouldnt return anything');


delete_test_data($dbh);
done_testing();

sub delete_test_data {
    my $vrtrack = shift;
    $dbh->do('delete from current_studies where name="ABC study"');
    $dbh->do('delete from current_aliquots where sample_internal_id=2222');
    $dbh->do('delete from current_samples where name="ABC sample"');
    $dbh->do('delete from current_pac_bio_library_tubes where name="Library name"');
}