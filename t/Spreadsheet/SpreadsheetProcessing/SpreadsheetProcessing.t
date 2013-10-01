#!/usr/bin/env perl
use strict;
use warnings;
use File::Temp;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

# check processor
ok my $spreadsheet_processor = UpdatePipeline::Spreadsheet::SpreadsheetProcessing->new(filename => 't/data/external_data_example.xls'), 'open example spreadsheet';
is $spreadsheet_processor->validate(), 1, 'example is valid'; 

# try running fix
ok $spreadsheet_processor->fix(), 'run fix';

# try writing report
ok $spreadsheet_processor->report($destination_directory.'/reportfile.csv'), 'run report';

ok -s $destination_directory.'/reportfile.csv', 'report file written';
done_testing();