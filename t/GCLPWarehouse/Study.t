#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('GCLPWarehouse::Study');
    use GCLPWarehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = GCLPWarehouse::Database->new(settings => $database_settings->{gclpwarehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into study (id_lims,id_study_lims,data_access_group) values("SQSCP",123, "unix_group_1")');
$dbh->do('insert into study (id_lims,id_study_lims,data_access_group) values("SQSCP",456, "unix_group_1 unix_group_2")');
$dbh->do('insert into study (id_lims,id_study_lims,data_access_group) values("SQSCP",789, NULL)');

##### lookup with no groups
ok(my $filemd_no_group = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 789), 'create a file meta data with no groups');
is($filemd_no_group->data_access_group, undef, 'data_access_group should be undef to begin with');
ok(my $warehouse_study_with_no_group = GCLPWarehouse::Study->new(file_meta_data => $filemd_no_group, _dbh => $dbh), 'initialise warehouse study object with file metadata for no group');
ok($warehouse_study_with_no_group->populate(), 'populate file metadata with no group');
is($filemd_no_group->data_access_group, undef, 'data_access_group should be undef if no group found');

##### lookup one group
ok(my $filemd_one_group = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 123), 'create a file meta data for one group');
is($filemd_one_group->data_access_group, undef, 'data_access_group should be undef to begin with');
ok(my $warehouse_study_with_one_group = GCLPWarehouse::Study->new(file_meta_data => $filemd_one_group, _dbh => $dbh), 'initialise warehouse study object with file metadata for one group');
ok($warehouse_study_with_one_group->populate(), 'populate file metadata with one group');
is($filemd_one_group->data_access_group, "unix_group_1", 'data access group should have been populated');

##### lookup two groups
ok(my $filemd_two_group = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 456), 'create a file meta data for two groups');
is($filemd_two_group->data_access_group, undef, 'data_access_group should be undef to begin with');
ok(my $warehouse_study_with_two_group = GCLPWarehouse::Study->new(file_meta_data => $filemd_two_group, _dbh => $dbh), 'initialise warehouse study object with file metadata for two groups');
ok($warehouse_study_with_two_group->populate(), 'populate file metadata with two groups');
is($filemd_two_group->data_access_group, "unix_group_1 unix_group_2", 'data access groups should have been populated');

delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $dbh->do('delete from study where id_study_lims=123');
  $dbh->do('delete from study where id_study_lims=456');
  $dbh->do('delete from study where id_study_lims=789');
}