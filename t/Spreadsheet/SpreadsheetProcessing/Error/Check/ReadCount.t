#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount');
}

# supply valid data
my $cell_data = 2000;
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount->new( row => 1, cell_data => $cell_data ), 'check valid read count';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid read count';

# read count missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount->new( row => 1, cell_data => $cell_data ), 'read count missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found';
is $error_list->[0]->description(), 'read count not supplied', 'read count missing';

# read count format
$cell_data = 'large';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::ReadCount->new( row => 1, cell_data => $cell_data ), 'read count has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'read count is not an integer', 'found read count format error';

done_testing();