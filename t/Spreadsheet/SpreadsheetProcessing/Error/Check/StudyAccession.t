#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession');
}

# supply valid data
my $cell_data = "ERS000001";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data does not generate warning
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession->new( cell_data => $cell_data ), 'missing accession';
is scalar @{$check_missing->error_list()}, 0, 'no errors found for missing data';

# invalid data entered
$cell_data = 'not valid accession';
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::StudyAccession->new( cell_data => $cell_data ), 'invalid accession';
ok my $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'non-word in study accession number', 'error for invalid accession';

done_testing();