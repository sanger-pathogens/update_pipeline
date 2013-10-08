#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename');
}

# supply valid data
my $cell_data = 'file_2.fastq.gz';
ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'check valid filename';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid filename';

# filename missing
$cell_data = undef;
ok my $check_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'filename missing';
is scalar @{$check_missing->error_list()}, 0, 'no errors found when filename not supplied';

# file has path
$cell_data = 'path/to/file_2.fastq.gz';
ok my $check_path = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'filename has path';
ok my $error_list = $check_path->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment mate filename has directory path', 'found filename has path error';

# filename missing after path removal
$cell_data = 'path/to/nowhere/';
ok my $check_path_and_missing = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'filename missing after path removed';
ok $error_list = $check_path_and_missing->error_list(), 'got error list';
is scalar @$error_list, 2, 'two errors found';
is $error_list->[0]->description(), 'experiment mate filename has directory path', 'found filename has path error';
is $error_list->[1]->description(), 'experiment mate filename not supplied', 'found filename missing after path removal error';

# file has lead/trail spaces
$cell_data = ' file_2.fastq.gz ';
ok my $check_space = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'filename has lead/trail spaces';
ok $error_list = $check_space->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment mate filename lead/trail space', 'found filename lead/trail space error';

# file format
$cell_data = 'non-words-in-file_2.fastq.gz';
ok my $check_format = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename->new( row => 1, cell_data => $cell_data ), 'filename has format error';
ok $error_list = $check_format->error_list(), 'got error list';
is scalar @$error_list, 1, 'one error found';
is $error_list->[0]->description(), 'experiment mate filename format error', 'found filename format error';

done_testing();