#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleName');
}

# supply valid data
my $cell_data = 'sample';
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleName->new( row => 1, cell_data => $cell_data ), 'check valid sample name';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid sample name';

# sample name missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleName->new( row => 1, cell_data => $cell_data ), 'sample name missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'sample name not supplied', 'sample name missing';

done_testing();