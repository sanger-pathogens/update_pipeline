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
    
    
    my $irods_file = Test::MockObject->new();
    $irods_file->fake_module( 'IRODS::File', test => sub{1} );
    $irods_file->fake_new( 'IRODS::File' );
    $irods_file->mock('file_attributes', sub{ {md5 => 'abcefg12345667', run => 'run123', well => 'A02'} });

    $ENV{VRTRACK_RW_USER} = 'root';
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();

delete_test_data($dbh);

my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_vrtrack_test_data($vrtrack);
VRTrack::Species->create($vrtrack, 'PBBacteria' );

my $script_name = 'UpdatePipeline::CommandLine::UpdatePBPipeline';
my $cwd = getcwd();

local $ENV{PATH} = "$ENV{PATH}:./bin";

# help text
mock_execute_script( $script_name, ['-h']);
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