#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FragmentSizeFormat');
}

# instantiate
ok my $error = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FragmentSizeFormat->new(), 'instantiate error';

# autofix
is $error->autofix('200'),       '200', 'no fix for valid data';
is $error->autofix('200 bp'),    '200', 'fix for fixable invalid data';
is $error->autofix('200 bases'), '200', 'fix for fixable invalid data';
is $error->autofix(' 200 '),     '200', 'fix for fixable invalid data';
is $error->autofix('medium'),      '0', 'unset';

done_testing();