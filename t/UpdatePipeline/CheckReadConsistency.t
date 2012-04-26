#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 18;
    use_ok('UpdatePipeline::CheckReadConsistency');
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::Validate;
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use UpdatePipeline::VRTrack::Sample;
    use UpdatePipeline::VRTrack::Library;
    use UpdatePipeline::VRTrack::Lane;
    use UpdatePipeline::VRTrack::File;
    use UpdatePipeline::VRTrack::LaneMetaData;
    use UpdatePipeline::VRTrack::Study;
    use UpdatePipeline::Exceptions;
}

#create a vrtrack object
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
#make sure that there is no leftover test data in the test database
delete_test_data($vrtrack);


VRTrack::Species->create($vrtrack, 'SomeBacteria' );
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
my $vstudy = UpdatePipeline::VRTrack::Study->new(accession => 'EFG456',_vr_project => $vproject)->vr_study();
$vproject->update;
my $vr_sample = UpdatePipeline::VRTrack::Sample->new(name => 'My name',common_name => 'SomeBacteria',accession => "ABC123", _vrtrack => $vrtrack,_vr_project => $vproject)->vr_sample();
my $vr_library = UpdatePipeline::VRTrack::Library->new(name => 'My library name', external_id  => 123,fragment_size_from => 123,fragment_size_to => 999, _vrtrack => $vrtrack,_vr_sample  => $vr_sample)->vr_library();
my $vr_lane = UpdatePipeline::VRTrack::Lane->new(name  => '1234_5#6', total_reads => 100000 ,_vrtrack => $vrtrack,_vr_library => $vr_library)->vr_lane();
my $lane_metadata = UpdatePipeline::VRTrack::LaneMetaData->new(name => '1234_5#6',_vrtrack => $vrtrack)->lane_attributes;
my @studies = ('EFG456');




#######################################################
#Core tests for UpdatePipeline::CheckReadConsistency.pm
#######################################################
my $consistency_evaluator = UpdatePipeline::CheckReadConsistency->new( _vrtrack => $vrtrack, environment => 'test' );

isa_ok( $consistency_evaluator, 'UpdatePipeline::CheckReadConsistency' );
can_ok( $consistency_evaluator, 'read_counts_are_consistent' );
can_ok( $consistency_evaluator, '_database_name' );
can_ok( $consistency_evaluator, '_config_settings' );
can_ok( $consistency_evaluator, '_full_path_by_lane_name' );
can_ok( $consistency_evaluator, '_full_path_by_lane_name' );
can_ok( $consistency_evaluator, '_fastq_file_names_by_lane_name' );
is( $consistency_evaluator->_database_name, 'vrtrack_test', 'Database name is correct.' );

#the directory root is set in the "config.yml". This root is bound 
#to a database name. See "config.yml" for details
is( $consistency_evaluator->_fastq_root_path, 't/data/', 'Root directory for the vrtrack fastq files could be traced via config.yml.' );

#There are 10 reads in each of the two *.fastq.gz files below
my $vr_file1 = UpdatePipeline::VRTrack::File->new( name => '1234_5#6_1.fastq.gz', md5 => 'abc1231343432432432', _vrtrack => $vrtrack, _vr_lane => $vr_lane )->vr_file();
my $vr_file2 = UpdatePipeline::VRTrack::File->new( name => '1234_5#6_2.fastq.gz', md5 => 'abc1231343432432433', _vrtrack => $vrtrack, _vr_lane => $vr_lane )->vr_file();

#test if the file names are retrieved correctly via the internal methods
my $fastq_file_names = $consistency_evaluator->_fastq_file_names_by_lane_name('1234_5#6');                               
is_deeply([sort @$fastq_file_names], [ '1234_5#6_1.fastq.gz', '1234_5#6_2.fastq.gz'], 'Test file (*.gz) names have been traced via the class methods.');

#test a routine comparison run between irods and the lane
is( $consistency_evaluator->read_counts_are_consistent( { lane_name => '1234_5#6', irods_read_count => 20 } ), 1, 'Comparing gzipped fastq count (20) to an imaginary irods counterpart with the same count' );

#test a comparison run, where irods count will not be consistent with the vrtrack count
isnt( $consistency_evaluator->read_counts_are_consistent( { lane_name => '1234_5#6', irods_read_count => 50 } ), 1, 'Conflicting iRODS vs VRTrack counts should always return a zero when using the read_counts_are_consistent function' );

#test comparison when the lane is associated with a non-existing file (same as wrong paths)
throws_ok { $consistency_evaluator->_count_line_tetrads_in_gzipped_fastq_file('non_existing_dummy_fastq.gz') } 'UpdatePipeline::Exceptions::FileNotFound', 'Throwing UpdatePipeline::Exceptions::FileNotFound when lane is associated with non-existing files or wrong file paths';


#Access the methods via the validator interface
my $validator = UpdatePipeline::Validate->new(study_names => \@studies, _vrtrack => $vrtrack );

#overwrite the default consistency evaluator with our test object
$validator->_consistency_evaluator($consistency_evaluator);

#check the root path, this time via the UpdatePipeline::Validator
is( $validator->_consistency_evaluator->_fastq_root_path, 't/data/', 'Root directory for the vrtrack fastq files could be traced via config.yml.' );

is( $validator->_irods_and_vrtrack_read_counts_are_consistent('1234_5#6', 20), 1, 'Comparing gzipped fastq count (20) to an imaginary irods counterpart with the same count via UpdatePipeline::Validator' );



##################################################################################
#ADD A WRONG FILE TYPE TO THE VR-TRACK FILE-SYSTEM AND ASSOCIATE WITH THE LANE!!!#
##################################################################################
my $vr_file3 = UpdatePipeline::VRTrack::File->new( name => 'non_gzipped.fastq', md5 => 'abc1231343432432433', _vrtrack => $vrtrack, _vr_lane => $vr_lane )->vr_file();

#Now that the lane is associated with wrong file type, this should throw exception
throws_ok { $consistency_evaluator->read_counts_are_consistent( { lane_name => '1234_5#6', irods_read_count => 20 } ) } 'UpdatePipeline::Exceptions::CommandFailed', 'Non-gzipped files should trigger UpdatePipeline::Exceptions::CommandFailed (this also proves that "set -o pipefail" work properly _count_line_tetrads_in_gzipped_fastq_file)';


#Now that the lane is associated with wrong file type, this will return 0 
is( $validator->_irods_and_vrtrack_read_counts_are_consistent('1234_5#6', 20), 0, 'Comparing gzipped fastq count (20) to an imaginary irods counterpart with the same count via UpdatePipeline::Validator, where there is some error in the vrtrack filesystem' );


done_testing;

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name in ("My name")');
  $vrtrack->{_dbh}->do('delete from individual where name in ("My name")');
  $vrtrack->{_dbh}->do('delete from species where name="SomeBacteria"');
  $vrtrack->{_dbh}->do('delete from library where name in ("My library name")');
  $vrtrack->{_dbh}->do('delete from seq_centre where name in ("SC")');
  $vrtrack->{_dbh}->do('delete from seq_tech where name in ("SLX")');
  $vrtrack->{_dbh}->do('delete from lane where name in ("1234_5#6","9876_5#4")');
  $vrtrack->{_dbh}->do('delete from file where name in ("1234_5#6_1.fastq.gz","1234_5#6_1.fastq.gz")');
  $vrtrack->{_dbh}->do('delete from file where lane_id in (8000)');
  $vrtrack->{_dbh}->do('delete from study where acc in ("EFG456")');
}
