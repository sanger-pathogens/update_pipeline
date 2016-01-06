#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './lib') }
BEGIN {
    use Test::Most;
    use_ok('Warehouse::Library');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = Warehouse::Database->new(settings => $database_settings->{warehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into current_library_tubes (name,internal_id,fragment_size_required_from,fragment_size_required_to,is_current) values("Library tube name",1111,200,300,1)');
$dbh->do('insert into current_multiplexed_library_tubes (name,internal_id,is_current) values("Multiplexed library tube name",2222,1)');

### pass in an ssid for a library tube
ok my $fm_ssid_library_tube = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 1111), 'create file metadata with library tube ssid';
ok (Warehouse::Library->new(file_meta_data => $fm_ssid_library_tube, _dbh => $dbh)->populate());
is $fm_ssid_library_tube->library_name, "Library tube name", 'library name should be populated';

### pass in an ssid for a multiplexed library tube
ok my $fm_ssid_multiplexed_library_tube = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 2222), 'create file metadata with multiplexed library tube ssid';
ok (Warehouse::Library->new(file_meta_data => $fm_ssid_multiplexed_library_tube, _dbh => $dbh)->populate());
is $fm_ssid_multiplexed_library_tube->library_name, "Multiplexed library tube name", 'library name should be populated from multiplexed table';

### pass in a name for a library tube
ok my $fm_name_library_tube = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_name => "Library tube name"), 'create file metadata with library tube name';
ok (Warehouse::Library->new(file_meta_data => $fm_name_library_tube, _dbh => $dbh)->populate());
is $fm_name_library_tube->library_ssid, 1111, 'library ssid should be populated';

### pass in a name for a multiplexed library tube
ok my $fm_name_multiplexed_library_tube = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_name => "Multiplexed library tube name"), 'create file metadata with multiplexed library tube name';
ok (Warehouse::Library->new(file_meta_data => $fm_name_multiplexed_library_tube, _dbh => $dbh)->populate());
is $fm_name_multiplexed_library_tube->library_ssid, 2222, 'library ssid should be populated from multiplexed table';

# populate the fragment sizes based on the library ssid.
ok (Warehouse::Library->new(file_meta_data => $fm_ssid_library_tube, _dbh => $dbh)->post_populate());
is $fm_ssid_library_tube->fragment_size_from, undef, 'fragment size from shouldnt be populated for a multiplexed lane';
is $fm_ssid_library_tube->fragment_size_to, undef, 'fragment size to should be populated for a multiplexed lane';

# fragment sizes already set so dont change
ok my $fm_ssid_library_tube_frag_sizes_exist = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', library_ssid => 1111, fragment_size_from => 1, fragment_size_to => 9), 'create file metadata with library tube ssid where fragment sizes already exist';
ok (Warehouse::Library->new(file_meta_data => $fm_ssid_library_tube_frag_sizes_exist, _dbh => $dbh)->populate());
is $fm_ssid_library_tube_frag_sizes_exist->fragment_size_from, 1, 'fragment size from should not be changed if it already exists';
is $fm_ssid_library_tube_frag_sizes_exist->fragment_size_to, 9, 'fragment size to should not be changed if it already exists';

delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $dbh->do('delete from current_library_tubes where internal_id=1111');
  $dbh->do('delete from current_multiplexed_library_tubes where internal_id=2222');
}