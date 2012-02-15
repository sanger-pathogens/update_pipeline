#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 17;
    use_ok('UpdatePipeline::ExceptionReporter');
    use UpdatePipeline::Exceptions;
}

ok my $exception_reporter = UpdatePipeline::ExceptionReporter->new(), 'initialise the exception reporter';

eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "SomeCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'common name exception added okay';}
eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "AnotherCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'common name exception added okay';}
eval { UpdatePipeline::Exceptions::UnknownCommonName->throw(error => "AnotherCommonName"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'same common name thrown twice';}

eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "1234_5#6"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'total reads exception added okay';}
eval { UpdatePipeline::Exceptions::TotalReadsMismatch->throw(error => "2222_5#6"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'total reads exception added okay';}

eval { UpdatePipeline::Exceptions::UndefinedSampleName->throw(error => "9999_8"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'UndefinedSampleName exception added okay';}

eval { UpdatePipeline::Exceptions::CouldntCreateLane->throw(error => "some error message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'unclassified exception added okay';}
eval { UpdatePipeline::Exceptions::CouldntCreateLane->throw(error => "some error message"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'unclassified exception added okay';}

eval { UpdatePipeline::Exceptions::UndefinedSampleCommonName->throw(error => "sample_123"); };
if(my $exception = Exception::Class->caught()){ ok $exception_reporter->add_exception($exception), 'UndefinedSampleCommonName exception added okay';}

ok $exception_reporter->_build_report(), 'build the report';
my %expected_unknown_common_names = ("SomeCommonName" => 1 ,"AnotherCommonName" => 2);
is_deeply $exception_reporter->_unknown_common_names, \%expected_unknown_common_names, 'list of common names';

my @expected_inconsistent_total_reads = ("1234_5#6","2222_5#6");
is_deeply $exception_reporter->_inconsistent_total_reads, \@expected_inconsistent_total_reads, 'list of inconsistent file names';

is $exception_reporter->_unclassified_exception_counter, 2, 'unclassified exception count';

my @expected_undef_common_names = ("sample_123");
is_deeply $exception_reporter->_undefined_common_names, \@expected_undef_common_names, 'undefined common names';

my @expected_bad_irods_records = ("9999_8");
is_deeply $exception_reporter->_bad_irods_records, \@expected_bad_irods_records, 'bad irods records';
