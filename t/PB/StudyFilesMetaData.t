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
    use_ok('UpdatePipeline::PB::StudyFilesMetaData');
 
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {study_name => 'ABC study', sample_common_name => 'Sample common name', md5 => 'abcefg12345667', run => 'run123', ebi_run_acc => 'ERR1234', well => 'A02', library_id => '3333', library_name => 'Library name', sample => 'ABC sample', sample_public_name => 'Sample supplier name', study_id => '1111', sample_id => '2222', sample_accession_number => 'HIJ456'} });


}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();

delete_test_data($dbh);

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
                   'ebi_run_acc' => 'ERR1234',
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