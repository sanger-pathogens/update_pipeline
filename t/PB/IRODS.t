#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp;
use Test::MockObject;


BEGIN { unshift( @INC, './lib' ) }
BEGIN { unshift( @INC, './t/lib' ) }

BEGIN {
    use Test::Most;
    use Pathogens::ConfigSettings;
    use MLWarehouse::Database;
    use_ok('UpdatePipeline::PB::IRODS');
    
    # mock the call to the IRODS::Study
    my $irods_study = Test::MockObject->new();
    $irods_study->fake_module( 'IRODS::Study', test => sub{1} );
    $irods_study->fake_new( 'IRODS::Study' );
    my @study_file_locations = ("/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5");
    $irods_study->mock('file_locations', sub{ \@study_file_locations });
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {study_name => 'ABC study', sample_common_name => 'Sample common name', md5 => 'abcefg12345667', run => '123', ebi_run_acc => 'ERR1234', well => 'A02', library_id => '3333', library_name => 'Library name', sample => 'ABC sample', sample_public_name => 'Sample supplier name', study_id => '1111', sample_id => '2222', sample_accession_number => 'HIJ456', study_accession_number => 'EFG123', file_location => '/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5'} });

}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = MLWarehouse::Database->new( settings => $database_settings->{ml_warehouse} )->connect;

ok(my $obj = UpdatePipeline::PB::IRODS->new(
    study_names        => ['ABC study'],
    ml_warehouse_dbh => $dbh
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
                   'file_location' => '/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5',
                   'lane_name' => '123_A02',
                   'ebi_run_acc' => 'ERR1234',
                   'md5' => 'abcefg12345667'
                 }, 'UpdatePipeline::PB::FileMetaData' )
        ], $obj->files_metadata(),'files found');

done_testing();
