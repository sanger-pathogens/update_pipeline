#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology');
}

# supply valid data
my $cell_data = 'Illumina';
ok my $check_slx = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology->new( cell_data => $cell_data ), 'check valid example (slx)';
is scalar @{$check_slx->error_list()}, 0, 'no errors found for valid data (slx)';

$cell_data = '454';
ok my $check_454 = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology->new( cell_data => $cell_data ), 'check valid example (slx)';
is scalar @{$check_454->error_list()}, 0, 'no errors found for valid data (454)';

# unknown tech generates error
$cell_data = 'unknown_technology';
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology->new( cell_data => $cell_data ), 'unknown tech';
ok my $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'sequencing technology not recognised', 'unknown tech error found';


# missing data generates error
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SequencingTechnology->new( cell_data => $cell_data ), 'missing name';
ok $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'sequencing technology not supplied', 'missing data error found';

done_testing();