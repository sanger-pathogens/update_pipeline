#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SangerContact');
}

# supply valid data
my $cell_data = "John Smith";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SangerContact->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data generates error
$cell_data = undef;
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SangerContact->new( cell_data => $cell_data ), 'missing name';
ok my $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'sanger contact not supplied', 'missing name error found';

done_testing();