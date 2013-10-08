#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID');
}

# supply valid data
my $cell_data = 12345;
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID->new( row => 1, cell_data => $cell_data ), 'check valid taxon id';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid taxon id';

# taxon id missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID->new( row => 1, cell_data => $cell_data ), 'taxon id missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'taxon id not supplied', 'taxon id missing';

# taxon id format
$cell_data = 'organism name';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID->new( row => 1, cell_data => $cell_data ), 'taxon id has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'taxon id not an integer', 'found taxon id format error';

# taxon id is zero
$cell_data = 0;
ok my $check_zero = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::TaxonID->new( row => 1, cell_data => $cell_data ), 'taxon id is zero';
ok $error_list = $check_zero->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'taxon id is zero', 'found taxon id format error';

done_testing();