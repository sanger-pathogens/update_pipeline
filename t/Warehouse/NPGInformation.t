#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('Warehouse::NPGInformation');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}
# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new(environment => 'test', filename => 'database.yml')->settings();
my $dbh = Warehouse::Database->new(settings => $database_settings->{warehouse})->connect;

delete_test_data($dbh);
$dbh->do('insert into npg_information (study_id, sample_id, asset_id, asset_name,id_run,position,insert_size_median,paired_read ) values(111,222,333,"my library",1234,5,200,1)');

# multiplexed lane -> all pieces of information are missing 
ok my $file_meta_data = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6'), 'create file object with multiplexed filename';
ok (Warehouse::NPGInformation->new(file_meta_data => $file_meta_data, _dbh => $dbh)->populate());
is $file_meta_data->study_ssid, 111, 'study ssid populated';
is $file_meta_data->sample_ssid, undef, 'sample_ssid not populated from overall lane';
is $file_meta_data->library_ssid, undef, 'library_ssid  not populated from overall lane';
is $file_meta_data->library_name, undef, 'library_name  not populated from overall lane';
is $file_meta_data->lane_is_paired_read, 1, 'is paired populated';


# multiplexed lane -> one piece of information is misisng, dont update the rest
ok my $file_meta_data_one_missing = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', sample_ssid => 555, library_ssid => 666), 'create file object with multiplexed filename and most data populated';
ok (Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_one_missing, _dbh => $dbh)->populate());
is $file_meta_data_one_missing->study_ssid, 111, 'study ssid updated';
is $file_meta_data_one_missing->sample_ssid, 555, 'sample_ssid  not updated';
is $file_meta_data_one_missing->library_ssid, 666, 'library_ssid not updated';

# multiplexed lane -> no information is missing
ok my $file_meta_data_none_missing = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', study_ssid => 999, sample_ssid => 555, library_ssid => 666), 'create file object with multiplexed filename and most data populated';
ok (Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_none_missing, _dbh => $dbh)->populate());
is $file_meta_data_none_missing->study_ssid, 999, 'study ssid not updated';
is $file_meta_data_none_missing->sample_ssid, 555, 'sample_ssid  not updated';
is $file_meta_data_none_missing->library_ssid, 666, 'library_ssid not updated';


# a non multiplexed lane is passed in
ok my $file_meta_data_non_multiplexed = UpdatePipeline::FileMetaData->new(file_name => '1234_5.bam', file_name_without_extension =>  '1234_5'), 'create file object with non multiplexed filename';
ok (Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_non_multiplexed, _dbh => $dbh)->populate());
is $file_meta_data_non_multiplexed->study_ssid, 111, 'study ssid updated';
is $file_meta_data_non_multiplexed->sample_ssid, 222, 'sample_ssid updated';
is $file_meta_data_non_multiplexed->library_ssid, 333, 'library_ssid updated';
is $file_meta_data_non_multiplexed->library_name, "my library", 'library_name updated';

# lane doesnt exist in table
ok my $file_meta_data_lane_doesnt_exist = UpdatePipeline::FileMetaData->new(file_name => 'doesntexist.bam', file_name_without_extension =>  'doesntexist'), 'create file object where lane doesnt exist';
Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_lane_doesnt_exist, _dbh => $dbh)->populate();
is $file_meta_data_lane_doesnt_exist->study_ssid, undef, 'study ssid not updated';
is $file_meta_data_lane_doesnt_exist->sample_ssid, undef, 'sample_ssid not updated';
is $file_meta_data_lane_doesnt_exist->library_ssid, undef, 'library_ssid not updated';
is $file_meta_data_lane_doesnt_exist->library_name, undef, 'library_name not updated';


# post_process -> a non multiplexed lane passed in 
ok my $file_meta_data_non_multiplexed_post_process = UpdatePipeline::FileMetaData->new(file_name => '1234_5.bam', file_name_without_extension =>  '1234_5'), 'create file object with non multiplexed filename';
ok (Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_non_multiplexed_post_process, _dbh => $dbh)->post_populate());
is $file_meta_data_non_multiplexed_post_process->fragment_size_from, 200, 'fragment_size_from  updated when a non multiplexed lane passed in ';
is $file_meta_data_non_multiplexed_post_process->fragment_size_to, 200, 'fragment_size_to updated when a non multiplexed lane passed in ';


# insert size is missing
ok my $file_meta_data_multiplexed_post_process = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6'), 'create file object with a multiplexed filename';
ok !(Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_multiplexed_post_process, _dbh => $dbh)->post_populate());
is $file_meta_data_multiplexed_post_process->fragment_size_from, undef, 'fragment_size_from should not be updated to median insert size';
is $file_meta_data_multiplexed_post_process->fragment_size_to, undef, 'fragment_size_to should not be updated to median insert size';

# fragment sizes already exist
ok my $file_meta_data_frag_exists = UpdatePipeline::FileMetaData->new(file_name => '1234_5#6.bam', file_name_without_extension =>  '1234_5#6', fragment_size_from => 1 , fragment_size_to => 9), 'create file object with fragment sizes set';
ok !(Warehouse::NPGInformation->new(file_meta_data => $file_meta_data_frag_exists, _dbh => $dbh)->post_populate());
is $file_meta_data_frag_exists->fragment_size_from, 1, 'fragment_size_from should not be updated to median insert size if it already exists';
is $file_meta_data_frag_exists->fragment_size_to, 9, 'fragment_size_to not should not be updated to median insert size if it already exists';

delete_test_data($dbh);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;
  $dbh->do('delete from npg_information where id_run=1234');
}