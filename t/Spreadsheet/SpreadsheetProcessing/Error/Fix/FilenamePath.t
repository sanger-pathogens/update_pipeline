#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenamePath');
}

# instantiate
ok my $error = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenamePath->new(), 'instantiate error';

# autofix
is $error->autofix('filename'),          'filename', 'no fix for valid data';
is $error->autofix('/path/to/filename'), 'filename', 'fix for fixable invalid data';
is $error->autofix('/path/to/nowhere/'),      undef, 'no filename found';

done_testing();