#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::ExceptionHandler');
    use UpdatePipeline::Exceptions;
    use VRTrack::VRTrack;
    use DBI;
}
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);

ok my $exception_handler = UpdatePipeline::ExceptionHandler->new(_vrtrack => $vrtrack), 'initialise the exception reporter';

eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "SomeCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'common name exception added okay';}
eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "AnotherCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'common name exception added okay';}
eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "AnotherCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'same common name thrown twice';}

eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "1234_5#6"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'total reads exception added okay';}
eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "2222_5#6"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'total reads exception added okay';}

eval { UpdatePipeline::Exceptions::UndefinedSampleName->throw(error => "9999_8"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'UndefinedSampleName exception added okay';}

eval { UpdatePipeline::Exceptions::CouldntCreateLane->throw(error => "some error message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'unclassified exception added okay';}
eval { UpdatePipeline::Exceptions::CouldntCreateLane->throw(error => "some error message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'unclassified exception added okay';}

eval { UpdatePipeline::Exceptions::UndefinedSampleCommonName->throw(error => "sample_123"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler->add_exception($exception), 'UndefinedSampleCommonName exception added okay';}

ok $exception_handler->_exception_reporter->_build_report(), 'build the report';
my %expected_unknown_common_names = ("SomeCommonName" => 1 ,"AnotherCommonName" => 2);
is_deeply $exception_handler->_exception_reporter->_unknown_common_names, \%expected_unknown_common_names, 'list of common names';

my @expected_inconsistent_total_reads = ("1234_5#6","2222_5#6");
is_deeply $exception_handler->_exception_reporter->_inconsistent_total_reads, \@expected_inconsistent_total_reads, 'list of inconsistent file names';

is @{$exception_handler->_exception_reporter->_unclassified_exceptions}, 2, 'unclassified exception count';

my @expected_undef_common_names = ("sample_123");
is_deeply $exception_handler->_exception_reporter->_undefined_common_names, \@expected_undef_common_names, 'undefined common names';

my @expected_bad_irods_records = ("9999_8");
is_deeply $exception_handler->_exception_reporter->_bad_irods_records, \@expected_bad_irods_records, 'bad irods records';


# set min run Id to be 6000 and see if exception gets added.
ok my $exception_handler_min_run_id = UpdatePipeline::ExceptionHandler->new(_vrtrack => $vrtrack, minimum_run_id => 6000), 'initialise the exception reporter with min run id';
eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "some_error_message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler_min_run_id->add_exception($exception,"4123_1#1"), 'exception added with min run id';}
eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "some_other_error_message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler_min_run_id->add_exception($exception,"7000_1#3"), 'exception added with min run id';}
@expected_inconsistent_total_reads = ("some_other_error_message");
ok $exception_handler_min_run_id->_exception_reporter->_build_report(), 'build the report';
is_deeply $exception_handler_min_run_id->_exception_reporter->_inconsistent_total_reads, \@expected_inconsistent_total_reads, 'list of inconsistent file names should be empty';



# check to see if a lane gets unset properly
$vrtrack->{_dbh}->do('insert into lane (name,latest) values("test_lane_for_deletion",1)');
my $exception_handler_reset = UpdatePipeline::ExceptionHandler->new(_vrtrack => $vrtrack, update_if_changed => 1),
eval { UpdatePipeline::Exceptions::PathToLaneChanged->throw(error => "test_lane_for_deletion"); };
if(my $exception = Exception::Class->caught()){ ok $exception_handler_reset->add_exception($exception), 'path changed exception added';}

# check to see if the lane was updated properly
my $sth = $vrtrack->{_dbh}->prepare(qq[select latest from lane where name = "test_lane_for_deletion"]);
$sth->execute;
my @lane_details  = $sth->fetchrow_array;
is $lane_details[0], 0, 'lane has been reset';


delete_test_data($vrtrack);
done_testing();

sub delete_test_data
{
  my $vrtrack = shift;

  $vrtrack->{_dbh}->do('delete from lane where name in ("test_lane_for_deletion")');
}

