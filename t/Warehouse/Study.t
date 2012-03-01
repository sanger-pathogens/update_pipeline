#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('Warehouse::Study');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = Warehouse::Database->new(settings => $database_settings->{warehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into current_studies (name,internal_id,is_current) values("Study name",1111,1)');

##### pass in a valid study ssid and populate the study name
ok my $file_meta_data_with_study_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 1111), 'create a file meta data just with a study ssid';
is $file_meta_data_with_study_ssid->study_name, undef, 'study name should be undefined to begin with';
ok my $warehouse_study_with_study_ssid = Warehouse::Study->new(file_meta_data => $file_meta_data_with_study_ssid, _dbh => $dbh), 'initialise warehouse study object with file metadata just with study ssid';
ok $warehouse_study_with_study_ssid->populate(), 'populate file metadata with study name';
is $file_meta_data_with_study_ssid->study_name, "Study name", 'study name should have been populated';

### pass in an invalid study ssid 
ok my $file_meta_data_with_invalid_study_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 99999), 'create a file meta data just with an invalid study ssid';
Warehouse::Study->new(file_meta_data => $file_meta_data_with_invalid_study_ssid, _dbh => $dbh)->populate();
is $file_meta_data_with_invalid_study_ssid->study_name, undef, 'study name should not have been populated';

### pass in a valid study name and populate the study ssid
ok my $file_meta_data_with_study_name = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_name => "Study name"), 'create a file meta data just with a study name';
Warehouse::Study->new(file_meta_data => $file_meta_data_with_study_name, _dbh => $dbh)->populate();
is $file_meta_data_with_study_name->study_ssid, 1111, 'study ssid should have been populated';

### pass in an invalid study name
ok my $file_meta_data_with_invalid_study_name = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_name => "Study name which doesnt exist"), 'create a file meta with a study name that doesnt exist';
Warehouse::Study->new(file_meta_data => $file_meta_data_with_invalid_study_name, _dbh => $dbh)->populate();
is $file_meta_data_with_invalid_study_name->study_ssid, undef, 'study ssid should not have been populated if the study name doesnt exist';

### pass in a file metadata object which already has a ssid and name (and the name in the DB is different)
ok my $file_meta_data_with_study_name_and_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_name => "Different study name", study_ssid => 1111), 'create a file meta data with study name and ssid';
Warehouse::Study->new(file_meta_data => $file_meta_data_with_study_name_and_ssid, _dbh => $dbh)->populate();
is $file_meta_data_with_study_name_and_ssid->study_ssid, 1111, 'study ssid should not change';
is $file_meta_data_with_study_name_and_ssid->study_name, "Different study name", 'study name should not change if already set';


delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $dbh->do('delete from current_studies where name="Study name"');
}