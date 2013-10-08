#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::LibraryName');
}

# supply valid data
my $cell_data = 'library';
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::LibraryName->new( row => 1, cell_data => $cell_data ), 'check valid library name';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid library name';

# library name missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::LibraryName->new( row => 1, cell_data => $cell_data ), 'library name missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'library name not supplied', 'library name missing';

done_testing();