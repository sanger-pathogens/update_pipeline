#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameLeadTrailSpace');
}

# instantiate
ok my $error = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameLeadTrailSpace->new(), 'instantiate error';

# autofix
is $error->autofix('filename'),   'filename', 'no fix for valid data';
is $error->autofix(' filename '), 'filename', 'fix for fixable invalid data';

done_testing();