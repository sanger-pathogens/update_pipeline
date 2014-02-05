#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Fixer');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning');
}

# create dummy metadata
my %header_metadata = ( cell_a => 'fixable error',
                        cell_b => 'fatal error',
                        cell_c => 'warning' );

my @rows_metadata = ( { cell_d => 'fixable error' },
                      { cell_d => 'fatal error' },
                      { cell_d => 'warning', } );

# create list of generic header errors and warnings 
my @header_error = ();
push @header_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   cell => 'cell_a', fatal => 0 );
push @header_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   cell => 'cell_b', fatal => 1 );
push @header_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning->new( cell => 'cell_c' );

# create list of generic experiment errors and warnings
my @expt_error = ();
push @expt_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   row => 1, cell => 'cell_d', fatal => 0 );
push @expt_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error->new(   row => 2, cell => 'cell_d', fatal => 1 );
push @expt_error, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning->new( row => 3, cell => 'cell_d' );

# create fixer
ok my $fixer = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Fixer->new( header_metadata  => \%header_metadata,
                                                                               rows_metadata    => \@rows_metadata,
                                                                               header_error     => \@header_error,
                                                                               experiment_error => \@expt_error ), 'instantiate fixer';
# run basic fix
ok $fixer->fix_errors(), 'fix errors';

# check fixed data
my $fix_header_metadata = $fixer->header_metadata;
my $fix_rows_metadata   = $fixer->rows_metadata;

is_deeply($fix_header_metadata,{ cell_a => undef,
                                 cell_b => 'fatal error',
                                 cell_c => 'warning' }, 'header fixed');
                                 
is_deeply($fix_rows_metadata->[0], { cell_d => undef         }, 'expt fixable error fixed');
is_deeply($fix_rows_metadata->[1], { cell_d => 'fatal error' }, 'expt fatal error no action');
is_deeply($fix_rows_metadata->[2], { cell_d => 'warning'     }, 'expt warning no action');

done_testing();