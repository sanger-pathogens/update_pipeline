#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyName');
}

# supply valid data
my $cell_data = "Stuff: A Study.";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyName->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data generates error
$cell_data = undef;
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyName->new( cell_data => $cell_data ), 'missing name';
ok my $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'study name not supplied', 'missing name error found';

done_testing();