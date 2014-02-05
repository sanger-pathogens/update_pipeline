#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date');
}

# supply valid data
my $cell_data = "01.02.2013";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data generates warning
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date->new( cell_data => $cell_data ), 'missing date';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found for missing data';
is $error_list->[0]->description(), 'date not supplied', 'missing date warning found';

# invalid data entered
$cell_data = 'one year';
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date->new( cell_data => $cell_data ), 'invalid date';
ok $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'date format not recognised', 'error for invalid date';

done_testing();