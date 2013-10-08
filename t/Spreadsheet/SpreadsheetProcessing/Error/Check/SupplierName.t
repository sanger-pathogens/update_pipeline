#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierName');
}

# supply valid data
my $cell_data = "John Smith";
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierName->new( cell_data => $cell_data ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid data';

# missing data generates warning
$cell_data = undef;
ok my $check_invalid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::SupplierName->new( cell_data => $cell_data ), 'missing name';
ok my $error_list = $check_invalid->error_list(), 'got error list';
is scalar @$error_list, 1, 'one warning found';
is $error_list->[0]->description(), 'supplier name not supplied', 'missing name warning found';

done_testing();