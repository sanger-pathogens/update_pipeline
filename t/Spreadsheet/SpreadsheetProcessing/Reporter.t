#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Reporter');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning');
}

# create list of generic header errors and warnings 
my @list_of_header_errors = ();
push @list_of_header_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   cell => 'cell_a', fatal => 0 );
push @list_of_header_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   cell => 'cell_b', fatal => 1 );
push @list_of_header_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning->new( cell => 'cell_c' );

# create list of generic experiment errors and warnings
my @list_of_expt_errors = ();
push @list_of_expt_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   row => 1, cell => 'cell_a', fatal => 0 );
push @list_of_expt_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   row => 2, cell => 'cell_b', fatal => 1 );
push @list_of_expt_errors, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning->new( row => 3, cell => 'cell_c' );

my $expected_report_summary = qq["header errors",2\r\n"header warnings",1\r\n"experiment errors",2\r\n"experiment warnings",1\r\n];

my $expected_report_full = qq[Type,Location,Cell,Description,Fixable\r\nError,Header,cell_a,error,"fixable error"\r\nError,Header,cell_b,error,\r\nWarning,Header,cell_c,warning,\r\nError,1,cell_a,error,"fixable error"\r\nError,2,cell_b,error,\r\nWarning,3,cell_c,warning,\r\n"header errors",2\r\n"header warnings",1\r\n"experiment errors",2\r\n"experiment warnings",1\r\n];

# open filehandle to variable
my $report = '';
open( my $report_fh, '>', \$report );

# check reporter
ok my $reporter = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Reporter->new( filehandle       => $report_fh,
                                                                                     header_error     => \@list_of_header_errors,
                                                                                     experiment_error => \@list_of_expt_errors ), 'created reporter';

ok $reporter->summary_report, 'wrote summary report';
is $report, $expected_report_summary, 'summary text';

close $report_fh; $report = ''; open( $report_fh, '>', \$report ); # reset output

ok $reporter->full_report, 'wrote full report';
is $report, $expected_report_full, 'full report text';

done_testing();