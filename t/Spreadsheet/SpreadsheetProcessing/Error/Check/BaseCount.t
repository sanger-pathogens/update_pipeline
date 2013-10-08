#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount');
}

# supply valid data
my $cell_data = 200000;
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount->new( row => 1, cell_data => $cell_data ), 'check valid base count';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid base count';

# base count missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount->new( row => 1, cell_data => $cell_data ), 'base count missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found';
is $error_list->[0]->description(), 'base count not supplied', 'base count missing';

# base count format
$cell_data = 'large';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::BaseCount->new( row => 1, cell_data => $cell_data ), 'base count has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'base count is not an integer', 'found base count format error';

done_testing();