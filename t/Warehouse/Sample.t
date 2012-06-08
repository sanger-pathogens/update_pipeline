#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('Warehouse::Sample');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = Warehouse::Database->new(settings => $database_settings->{warehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into current_samples (name,internal_id,common_name,is_current,supplier_name) values("Sample name",1111,"Some Common name",1,"Supplier name")');

##### pass in a valid sample ssid and populate the sample name
ok my $file_meta_data_with_sample_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_ssid => 1111), 'create a file meta data just with a sample ssid';
is $file_meta_data_with_sample_ssid->sample_name, undef, 'sample name should be undefined to begin with';
ok my $warehouse_sample_with_sample_ssid = Warehouse::Sample->new(file_meta_data => $file_meta_data_with_sample_ssid, _dbh => $dbh), 'initialise warehouse sample object with file metadata just with sample ssid';
ok $warehouse_sample_with_sample_ssid->populate(), 'populate file metadata with sample name';
is $file_meta_data_with_sample_ssid->sample_name, "Sample name", 'sample name should have been populated';
is $file_meta_data_with_sample_ssid->sample_common_name, "Some Common name", 'common name should have been populated';

### pass in an invalid sample ssid 
ok my $file_meta_data_with_invalid_sample_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_ssid => 99999), 'create a file meta data just with an invalid sample ssid';
Warehouse::Sample->new(file_meta_data => $file_meta_data_with_invalid_sample_ssid, _dbh => $dbh)->populate();
is $file_meta_data_with_invalid_sample_ssid->sample_name, undef, 'sample name should not have been populated';
is $file_meta_data_with_invalid_sample_ssid->sample_common_name, undef, 'common name should not have been populated';

### pass in a valid sample name and populate the sample ssid
ok my $file_meta_data_with_sample_name = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_name => "Sample name"), 'create a file meta data just with a sample name';
Warehouse::Sample->new(file_meta_data => $file_meta_data_with_sample_name, _dbh => $dbh)->populate();
is $file_meta_data_with_sample_name->sample_ssid, 1111, 'sample ssid should have been populated';
is $file_meta_data_with_sample_name->sample_common_name, "Some Common name", 'common name should have been populated';

### pass in an invalid sample name
ok my $file_meta_data_with_invalid_sample_name = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_name => "Sample name which doesnt exist"), 'create a file meta with a sample name that doesnt exist';
Warehouse::Sample->new(file_meta_data => $file_meta_data_with_invalid_sample_name, _dbh => $dbh)->populate();
is $file_meta_data_with_invalid_sample_name->sample_ssid, undef, 'sample ssid should not have been populated if the sample name doesnt exist';
is $file_meta_data_with_invalid_sample_name->sample_common_name, undef, 'common name should not have been populated';

### pass in a file metadata object which already has a ssid and name (and the name in the DB is different). load in the common name
ok my $file_meta_data_with_sample_name_and_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_name => "Different sample name", sample_ssid => 1111), 'create a file meta data with sample name and ssid';
Warehouse::Sample->new(file_meta_data => $file_meta_data_with_sample_name_and_ssid, _dbh => $dbh)->populate();
is $file_meta_data_with_sample_name_and_ssid->sample_ssid, 1111, 'sample ssid should not change';
is $file_meta_data_with_sample_name_and_ssid->sample_name, "Different sample name", 'sample name should not change if already set';
is $file_meta_data_with_sample_name_and_ssid->sample_common_name, "Some Common name", 'common name should have been populated';

##### pass in sample ssid and post_populate the supplier_name
ok my $file_meta_data_for_post_populate = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_ssid => 1111), 'create a file meta data just with a sample ssid';
is $file_meta_data_for_post_populate->supplier_name, undef, 'supplier name should be undefined to begin with';
ok my $warehouse_sample_for_post_populate = Warehouse::Sample->new(file_meta_data => $file_meta_data_for_post_populate, _dbh => $dbh), 'initialise warehouse sample object with file metadata';
ok $warehouse_sample_for_post_populate->post_populate(), 'post_populate file metadata with supplier name';
is $file_meta_data_for_post_populate->supplier_name, undef, 'supplier name should be undef if sample name not defined';
ok $warehouse_sample_for_post_populate->populate(), 'now populate file metadata with sample name';
is $file_meta_data_for_post_populate->sample_name, "Sample name", 'check sample name is populated';
ok $warehouse_sample_for_post_populate->post_populate(), 'post_populate file metadata with supplier name';
is $file_meta_data_for_post_populate->supplier_name, "Supplier name", 'supplier name has been populated';

delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  #$dbh->do('delete from current_samples where name="Sample name"');
}