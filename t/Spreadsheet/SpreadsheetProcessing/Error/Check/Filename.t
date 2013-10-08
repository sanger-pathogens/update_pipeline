#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename');
}

# supply valid data
my $cell_data = 'file_1.fastq.gz';
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => 1, cell_data => $cell_data ), 'check valid filename';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid filename';

# filename missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => 1, cell_data => $cell_data ), 'filename missing';
ok my $error_list = $check_missing->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment filename not supplied', 'filename missing';

# file has path
$cell_data = 'path/to/file_1.fastq.gz';
ok my $check_path = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => 1, cell_data => $cell_data ), 'filename has path';
ok $error_list = $check_path->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment filename has directory path', 'found filename has path error';

# file has lead/trail spaces
$cell_data = ' file_1.fastq.gz ';
ok my $check_space = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => 1, cell_data => $cell_data ), 'filename has lead/trail spaces';
ok $error_list = $check_space->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment filename lead/trail space', 'found filename lead/trail space error';

# file format
$cell_data = 'non-words-in-file_1.fastq.gz';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename->new( row => 1, cell_data => $cell_data ), 'filename has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment filename format error', 'found filename format error';

done_testing();