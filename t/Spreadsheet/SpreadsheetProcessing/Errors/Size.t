#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size');
}

# supply valid data
my $cell_data = "2.2";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data generates warning
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size->new( cell_data => $cell_data ), 'missing size';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found for missing data';
is $error_list->[0]->description(), 'file size not supplied', 'missing date warning found';

# invalid data entered
$cell_data = 'big';
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size->new( cell_data => $cell_data ), 'invalid size';
ok $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'file size not a number', 'error for invalid date';

done_testing();