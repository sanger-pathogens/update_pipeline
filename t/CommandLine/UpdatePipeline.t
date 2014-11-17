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
    use_ok('UpdatePipeline::UpdateAllMetaData');
    
    
    my $warehouse = Test::MockObject->new();
    $warehouse->fake_module( 'Warehouse::FileMetaDataPopulation', test => sub{1} );
    $warehouse->fake_new( 'Warehouse::FileMetaDataPopulation' );
    $warehouse->mock('populate', sub{1});
    $warehouse->mock('post_populate', sub{1});
    
    # mock the call to the IRODS::Study
    my $irods_study = Test::MockObject->new();
    $irods_study->fake_module( 'IRODS::Study', test => sub{1} );
    $irods_study->fake_new( 'IRODS::Study' );
    my @study_file_locations = ("/seq/2442/2442_5.bam",);
    $irods_study->mock('file_locations', sub{ \@study_file_locations });

    # mock the call to IRODS::File
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new('IRODS::File');
    my %irods_file_expected_output = (
      alignment => '0',
      ebi_run_acc  => 'ERR5678',
      file_name => '2442_5.bam',
      file_name_without_extension => '2442_5',
      id_run => '2442',
      lane => '5',
      lane_manual_qc => 'pass',
      library => 'AB_CD_EF 1',
      library_id => '123456',
      manual_qc  => 'pass',
      md5 => '123456789abcdef',
      sample => 'AB_CD_EF',
      sample_id => '987',
      sample_accession_number => 'ABC0000123',
      sample_common_name => 'Bacteria',
      study => 'ABC_study',
      study_accession_number => 'ABC123',
      study_id => '1234',
      study_title => 'ABC_study',
      target => '1',
      total_reads => '100200300',
      type => 'bam',
      is_paired_read => 1,
      reference => '/path/to/reference'
    );
    $irods_file->mock('file_attributes', sub{ \%irods_file_expected_output });
    $irods_file->mock('lane_manual_qc', sub{ 'pass' });   
}

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_inserted_vrtrack_test_data($vrtrack);
delete_vrtrack_test_data($vrtrack);

VRTrack::Species->create($vrtrack, 'Bacteria' );


my $verbose_output = 0;
my $update_if_changed = 0;
my $errors_min_run_id = 1;
my $dont_use_warehouse = 0;
my $use_supplier_name =0;
my $taxon_id = 0;
my $common_name_required = $taxon_id ? 0 : 1;
my $specific_run_id =0;
my $specific_min_run =0;
my $no_pending_lanes =0;
my $override_md5 =0;
my $withdraw_del =0;
my $total_reads =0;

ok(my $update_pipeline = UpdatePipeline::UpdateAllMetaData->new(
    study_names               => ['ABC_study'], 
    _vrtrack                  => $vrtrack, 
    number_of_files_to_return => 5, 
    verbose_output            => 0, 
    minimum_run_id            => $errors_min_run_id, 
    update_if_changed         => $update_if_changed,
    dont_use_warehouse        => $dont_use_warehouse,
    common_name_required      => $common_name_required,
    taxon_id                  => $taxon_id,
    species_name              => 'Bacteria',
    use_supplier_name         => $use_supplier_name,
    specific_run_id           => $specific_run_id,
    specific_min_run          => $specific_min_run,
    no_pending_lanes          => $no_pending_lanes,
    override_md5              => $override_md5,
    vrtrack_lanes             => undef,
    add_raw_reads             => $total_reads,)
  , 'create the update metadata object');
ok($update_pipeline->update(), 'Run the update');

is("2442_5",         $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_lane where name like "2442_5"')->[0],'Lane name added');
is("ERR5678",         $vrtrack->{_dbh}->selectrow_arrayref('select acc from latest_lane where name like "2442_5"')->[0],'Lane accession added');
is("AB_CD_EF 1",    $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_library where name like "AB_CD_EF 1"')->[0],'Library name added');
is("AB_CD_EF",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_sample where name like "AB_CD_EF"')->[0],'Sample name added');
is("ABC_study",          $vrtrack->{_dbh}->selectrow_arrayref('select name from latest_project where name like "ABC_study"')->[0],'Project name added');
is("AB_CD_EF",          $vrtrack->{_dbh}->selectrow_arrayref('select name from individual where name like "AB_CD_EF"')->[0],'Individual name added');
is("2442_5.bam",$vrtrack->{_dbh}->selectrow_arrayref('select name from latest_file where name like "2442_5.bam"')->[0],'File name added');
is("/path/to/reference",$vrtrack->{_dbh}->selectrow_arrayref('select reference from latest_file where name like "2442_5.bam"')->[0],'File reference added');

delete_inserted_vrtrack_test_data($vrtrack);
delete_vrtrack_test_data($vrtrack);
done_testing();


sub delete_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from species where name="Bacteria"');
  delete_inserted_vrtrack_test_data($vrtrack);
}

sub delete_inserted_vrtrack_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="ABC_study"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("AB_CD_EF")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("AB_CD_EF")');
  $vrtrack->{_dbh}->do('delete from library where name in ("AB_CD_EF 1")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("2442_5")');
  $vrtrack->{_dbh}->do('delete from file where name in ("2442_5.bam")');
}

