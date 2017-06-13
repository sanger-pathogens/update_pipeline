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
    use_ok('UpdatePipeline::PB::UpdateAllMetaData');
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {study_name => 'ABC study', sample_common_name => 'Sample common name', md5 => 'abcefg12345667', run => '123', ebi_run_acc => 'ERR1234', well => 'A02', library_id => '3333', library_name => 'Library name', sample => 'ABC sample', sample_public_name => 'Sample supplier name', study_id => '1111', sample_id => '2222', sample_accession_number => 'HIJ456', study_accession_number => 'EFG123', file_location => '/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5'} });
    
    # mock the call to the IRODS::Study
    my $irods_study = Test::MockObject->new();
    $irods_study->fake_module( 'IRODS::Study', test => sub{1} );
    $irods_study->fake_new( 'IRODS::Study' );
    my @study_file_locations = ("/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5");
    $irods_study->mock('file_locations', sub{ \@study_file_locations });

    $ENV{VRTRACK_RW_USER} = 'root';
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_vrtrack_test_data($vrtrack);

VRTrack::Species->create($vrtrack, 'PBBacteria' );

my $script_name = 'UpdatePipeline::CommandLine::UpdatePBPipeline';
my $cwd = getcwd();

local $ENV{PATH} = "$ENV{PATH}:./bin";

# help text
mock_execute_script( $script_name, ['-h']);


ok(my $update_pipeline = UpdatePipeline::PB::UpdateAllMetaData->new(
    study_names               => ['ABC_study'], 
    _vrtrack                  => $vrtrack, 
    number_of_files_to_return => 5, 
    verbose_output            => 0, 
    minimum_run_id            => 1, 
    update_if_changed         => 1,
    dont_use_warehouse        => 0,
    common_name_required      => 0,
    taxon_id                  => 2,
    species_name              => 'PBBacteria',
    use_supplier_name         => 1,
    specific_run_id           => 1,
    specific_min_run          => 1,
    no_pending_lanes          => 0,
    override_md5              => 1,
    vrtrack_lanes             => undef,
    add_raw_reads             => 1,
	environment               => 'test'
    )
  , 'create the update metadata object');
ok($update_pipeline->update(), 'Run the update');

is("/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5",$vrtrack->{_dbh}->selectrow_arrayref('select name from latest_file where name like "/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5"')->[0],'File name added');
is("123_A02",         $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_lane where name like "123_A02"')->[0],'Lane name added');

delete_inserted_vrtrack_test_data($vrtrack);
delete_vrtrack_test_data($vrtrack);
done_testing();

sub delete_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from species where name="PBBacteria"');
  delete_inserted_vrtrack_test_data($vrtrack);
}

sub delete_inserted_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="ABC study"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("ABC sample")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("Sample supplier name")');
  $vrtrack->{_dbh}->do('delete from library where name in ("Library name")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("123_A02")');
  $vrtrack->{_dbh}->do('delete from file where name in ("/seq/pacbio/54424_1299/H02_1/Analysis_Results/m170611_193455_00127_c101203502550000001823285910241787_s1_p0.2.bax.h5")');
}