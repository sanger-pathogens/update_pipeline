#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize');
}

# supply valid data
my $cell_data = 200;
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize->new( row => 1, cell_data => $cell_data ), 'check valid fragment size';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid fragment size';

# fragment size missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize->new( row => 1, cell_data => $cell_data ), 'fragment size missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found';
is $error_list->[0]->description(), 'fragment size not supplied', 'fragment size missing';

# fragment size format
$cell_data = 'large';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::FragmentSize->new( row => 1, cell_data => $cell_data ), 'fragment size has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'fragment size is not an integer', 'found fragment size format error';

done_testing();