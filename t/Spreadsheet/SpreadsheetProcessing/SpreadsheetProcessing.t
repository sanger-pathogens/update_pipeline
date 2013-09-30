#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing');
}

# check processor
ok my $spreadsheet_processor = UpdatePipeline::Spreadsheet::SpreadsheetProcessing->new(filename => 't/data/external_data_example.xls'), 'open example spreadsheet';

is $spreadsheet_processor->validate(), 1, 'debug: expected result'; # expect no errors 

# debug
for my $err (@{ $spreadsheet_processor->_header_error })
{
    print $err->cell, " ", $err->description(), "\n"
}

# debug
for my $err (@{ $spreadsheet_processor->_experiment_error })
{
    print $err->cell, " ", $err->description(), "\n"
}

# try writing report
$spreadsheet_processor->report();

# try running fix
$spreadsheet_processor->fix();

# write second report
$spreadsheet_processor->report();


done_testing();