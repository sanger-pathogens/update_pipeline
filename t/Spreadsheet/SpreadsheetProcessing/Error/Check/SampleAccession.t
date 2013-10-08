#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession');
}

# supply valid data
my $cell_data = 'ERS000001';
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession->new( row => 1, cell_data => $cell_data ), 'check valid sample acc';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid sample acc';

# accession missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession->new( row => 1, cell_data => $cell_data ), 'sample acc missing';
is scalar @{$check_missing->error_list()}, 0, 'no errors found when sample acc not supplied';

# accession format
$cell_data = 'non-words-in-accession';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::SampleAccession->new( row => 1, cell_data => $cell_data ), 'sample acc has format error';
ok my $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'sample accession not recognised', 'found sample acc format error';

done_testing();