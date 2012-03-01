#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('Warehouse::Request');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = Warehouse::Database->new(settings => $database_settings->{warehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into current_requests (target_asset_internal_id,fragment_size_from, fragment_size_to,is_current) values(1111,150,250,1)');

##### library_ssid and fragment sizes not set in file metadata
ok my $file_meta_data_with_target_asset = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 1111), 'create file object with library ssid';
ok (Warehouse::Request->new(file_meta_data => $file_meta_data_with_target_asset, _dbh => $dbh)->post_populate());
is $file_meta_data_with_target_asset->fragment_size_from, 150, 'fragment_size_from should have been populated';
is $file_meta_data_with_target_asset->fragment_size_to, 250, 'fragment_size_to should have been populated';

#### library_ssid doesnt exist 
ok my $file_meta_data_with_nonexistant_library_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 9999), 'create file object with non existant library ssid';
ok (Warehouse::Request->new(file_meta_data => $file_meta_data_with_nonexistant_library_ssid, _dbh => $dbh)->post_populate());
is $file_meta_data_with_nonexistant_library_ssid->fragment_size_from, undef, 'fragment_size_from should not have been populated with a non existant library ssid';
is $file_meta_data_with_nonexistant_library_ssid->fragment_size_to, undef, 'fragment_size_to should not have been populated with a non existant library ssid';

#### library_ssid not defined
ok my $file_meta_data_with_undef_library_ssid = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6'), 'create file object with undef library ssid';
ok !(Warehouse::Request->new(file_meta_data => $file_meta_data_with_undef_library_ssid, _dbh => $dbh)->post_populate());
is $file_meta_data_with_undef_library_ssid->fragment_size_from, undef, 'fragment_size_from should not have been populated with an undef library ssid';
is $file_meta_data_with_undef_library_ssid->fragment_size_to, undef, 'fragment_size_to should not have been populated with an undef library ssid';

### library_ssid exists but fragement sizes already set in file metadata
ok my $file_meta_data_where_frag_sizes_exist = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 1111, fragment_size_from => 1, fragment_size_to => 9), 'create file object where frag sizes exist';
ok (Warehouse::Request->new(file_meta_data => $file_meta_data_where_frag_sizes_exist, _dbh => $dbh)->post_populate());
is $file_meta_data_where_frag_sizes_exist->fragment_size_from, 1, 'fragment_size_from should not have changed if it already exists';
is $file_meta_data_where_frag_sizes_exist->fragment_size_to, 9, 'fragment_size_to  should not have changed if it already exists';

delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $dbh->do('delete from current_requests where target_asset_internal_id=1111');
}