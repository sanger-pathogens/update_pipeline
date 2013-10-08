#!/usr/bin/env perl
use strict;
use warnings;
BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy');
}

# check valid rows
my @valid_row = ( { filename                => 'file_1', 
                    sample_name             => 'sample_1',
                    sample_accession_number => 'ERS000001',
                    taxon_id                => 1,
                    library_name            => 'lib_1' },
                  { filename                => 'file_2', 
                    sample_name             => 'sample_2',
                    sample_accession_number => 'ERS000002',
                    taxon_id                => 2,
                    library_name            => 'lib_2' },
                  { filename                => 'file_3', 
                    sample_name             => 'sample_3',
                    sample_accession_number => 'ERS000003',
                    taxon_id                => 3,
                    library_name            => 'lib_3' } );

ok my $check_valid = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => \@valid_row ), 'check valid example';
is scalar @{$check_valid->error_list()}, 0, 'no errors found for valid row';


my @unique_filename = ( { filename                => 'not_unique', 
                          sample_name             => '1',
                          sample_accession_number => undef,
                          taxon_id                => 1,
                          library_name            => '1' },
                        { filename                => 'not_unique', 
                          sample_name             => '2',
                          sample_accession_number => undef,
                          taxon_id                => 1,
                          library_name            => '2' },
                        { filename                => 'unique', 
                          sample_name             => '2',
                          sample_accession_number => undef,
                          taxon_id                => 1,
                          library_name            => '2' },
                        { filename                => 'not_unique', 
                          sample_name             => '3',
                          sample_accession_number => undef,
                          taxon_id                => 1,
                          library_name            => '3' } );

ok my $check_filename = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => \@unique_filename ), 'filename check';
my $filename_errors = $check_filename->_unique_fastq();

# parse error list
my @error_list = ();
for my $err (@$filename_errors)
{
    push @error_list, [$err->row, $err->description];
}

is_deeply( \@error_list, [ [1, 'experiment filename not unique'],
                           [2, 'experiment filename not unique'],
                           [4, 'experiment filename not unique'] ] ,'got expected error list');

my @library_to_sample = ( { filename                => 'file_1', 
                            sample_name             => 'sample_1',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_1' },
                            
                          { filename                => 'file_2', 
                            sample_name             => 'sample_1',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_2' },
                            
                          { filename                => 'file_3', 
                            sample_name             => 'sample_2',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_2' },
                            
                          { filename                => 'file_4', 
                            sample_name             => 'sample_1',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_2' } );

ok my $check_library_to_sample = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => \@library_to_sample ), 'lib to sample check';
my $library_to_sample_errors = $check_library_to_sample->_library_to_sample();

@error_list = ();
for my $err (@$library_to_sample_errors)
{
    push @error_list, [$err->row, $err->description];
}

is_deeply( \@error_list, [ [2, 'library maps to multiple samples'],
                           [3, 'library maps to multiple samples'],
                           [4, 'library maps to multiple samples'] ] ,'got expected error list');

my @sample_to_taxon = ( { filename                => 'file_1', 
                            sample_name             => 'sample_1',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_1' },
                            
                          { filename                => 'file_2', 
                            sample_name             => 'sample_2',
                            sample_accession_number => undef,
                            taxon_id                => 1,
                            library_name            => 'lib_2' },
                            
                          { filename                => 'file_3', 
                            sample_name             => 'sample_2',
                            sample_accession_number => undef,
                            taxon_id                => 2,
                            library_name            => 'lib_3' },
                            
                          { filename                => 'file_4', 
                            sample_name             => 'sample_3',
                            sample_accession_number => undef,
                            taxon_id                => 2,
                            library_name            => 'lib_4' } );

ok my $check_sample_to_taxon = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => \@sample_to_taxon ), 'sample to taxon check';
my $sample_to_taxon_errors = $check_sample_to_taxon->_sample_to_taxon();

@error_list = ();
for my $err (@$sample_to_taxon_errors)
{
    push @error_list, [$err->row, $err->description];
}

is_deeply( \@error_list, [ [2, 'sample name has multiple taxon ids'],
                           [3, 'sample name has multiple taxon ids'] ] ,'got expected error list');


my @sample_to_accession = ( { filename                => 'file_1', 
                            sample_name             => 'sample_1',
                            sample_accession_number => 'ERS000001',
                            taxon_id                => 1,
                            library_name            => 'lib_1' },
                            
                          { filename                => 'file_2', 
                            sample_name             => 'sample_2',
                            sample_accession_number => 'ERS000002',
                            taxon_id                => 1,
                            library_name            => 'lib_2' },
                            
                          { filename                => 'file_3', 
                            sample_name             => 'sample_2',
                            sample_accession_number => 'ERS000003',
                            taxon_id                => 1,
                            library_name            => 'lib_3' },
                            
                          { filename                => 'file_4', 
                            sample_name             => 'sample_3',
                            sample_accession_number => 'ERS000004',
                            taxon_id                => 1,
                            library_name            => 'lib_4' } );

ok my $check_sample_to_accession = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy->new( rows_metadata => \@sample_to_accession ), 'sample to accession check';
my $sample_to_accession_errors = $check_sample_to_accession->_sample_to_accession();

@error_list = ();
for my $err (@$sample_to_accession_errors)
{
    push @error_list, [$err->row, $err->description];
}

is_deeply( \@error_list, [ [2, 'sample name has multiple accession ids'],
                           [3, 'sample name has multiple accession ids'] ] ,'got expected error list');

done_testing();