#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt');
}

# Create valid example spreadsheet data
my %input_header = (
    supplier_name                  => 'valid name',
    supplier_organisation          => 'valid org',
    internal_contact               => 'valid contact',
    sequencing_technology          => 'Illumina',
    study_name                     => 'valid study name',
    study_accession_number         => 'ERS123',
    total_size_of_files_in_gbytes  => '1.1',
    data_to_be_kept_until          => '2013-10-02',
);

my @input_rows = (
  {
    filename                => 'valid_file_1.fastq.gz', 
    mate_filename           => 'valid_file_2.fastq.gz',
    sample_name             => 'valid_sample',
    sample_accession_number => 'valid_accession',
    taxon_id                => 12345,
    library_name            => 'valid_lib',
    fragment_size           => 200,
    raw_read_count          => 123456,
    raw_base_count          => 12345600,
    comments                => 'valid comment'
  }
);

# check validator
ok my $validator = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator->new( header_metadata => \%input_header,
                                                                                       rows_metadata   => \@input_rows ), 'created validator';
is $validator->total_errors_found, 0, 'total errors';

# Create invalid example spreadsheet data
%input_header = (
    supplier_name                  => undef,
    supplier_organisation          => undef,
    internal_contact               => undef,
    sequencing_technology          => undef,
    study_name                     => undef,
    study_accession_number         => 'not valid',
    total_size_of_files_in_gbytes  => undef,
    data_to_be_kept_until          => undef,
);

@input_rows = (
  {
    filename                => undef, 
    mate_filename           => undef,
    sample_name             => undef,
    sample_accession_number => 'not valid',
    taxon_id                => undef,
    library_name            => undef,
    fragment_size           => undef,
    raw_read_count          => undef,
    raw_base_count          => undef,
    comments                => undef
  },
  {
    filename                => 'not_unique', 
    mate_filename           => undef,
    sample_name             => '1',
    sample_accession_number => undef,
    taxon_id                => 1,
    library_name            => '1',
    fragment_size           => 100,
    raw_read_count          => 100,
    raw_base_count          => 10000,
    comments                => undef
  },
  {
    filename                => 'not_unique', 
    mate_filename           => undef,
    sample_name             => '2',
    sample_accession_number => undef,
    taxon_id                => 1,
    library_name            => '2',
    fragment_size           => 100,
    raw_read_count          => 100,
    raw_base_count          => 10000,
    comments                => undef
  }
);

ok $validator = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator->new( header_metadata => \%input_header,
                                                                                    rows_metadata   => \@input_rows ), 'created valdator (invalid)';

# errors and warnings from header
my $head_error_and_warn = $validator->header_error;
is $head_error_and_warn->[0]->description, 'supplier name not supplied',         'supplier name not supplied';
is $head_error_and_warn->[1]->description, 'supplier organisation not supplied', 'supplier organisation not supplied';
is $head_error_and_warn->[2]->description, 'sanger contact not supplied',        'sanger contact not supplied';
is $head_error_and_warn->[3]->description, 'sequencing technology not supplied', 'sequencing technology not supplied';
is $head_error_and_warn->[4]->description, 'study name not supplied',            'study name not supplied';
is $head_error_and_warn->[5]->description, 'non-word in study accession number', 'non-word in study accession number';
is $head_error_and_warn->[6]->description, 'file size not supplied',             'file size not supplied';
is $head_error_and_warn->[7]->description, 'date not supplied',                  'date not supplied';
is scalar @$head_error_and_warn, 8, 'found expected head errors and warnings';

# errors and warnings from expt
my $expt_error_and_warn = $validator->rows_error;
is $expt_error_and_warn->[0]->description, 'experiment filename not unique',   'experiment filename not unique';
is $expt_error_and_warn->[1]->description, 'experiment filename not unique',   'experiment filename not unique';
is $expt_error_and_warn->[2]->description, 'experiment filename not supplied', 'experiment filename not supplied';
is $expt_error_and_warn->[3]->description, 'sample name not supplied',         'sample name not supplied';
is $expt_error_and_warn->[4]->description, 'sample accession not recognised',  'sample accession not recognised';
is $expt_error_and_warn->[5]->description, 'taxon id not supplied',            'taxon id not supplied';
is $expt_error_and_warn->[6]->description, 'library name not supplied',        'library name not supplied';
is $expt_error_and_warn->[7]->description, 'fragment size not supplied',       'fragment size not supplied';
is $expt_error_and_warn->[8]->description, 'read count not supplied',          'read count not supplied';
is $expt_error_and_warn->[9]->description, 'base count not supplied',          'base count not supplied';
is scalar @$expt_error_and_warn, 10, 'found expected expt errors and warnings';

# errors from header
my $head_error = $validator->header_error_list;
is $head_error->[0]->description, 'supplier organisation not supplied', 'supplier organisation not supplied';
is $head_error->[1]->description, 'sanger contact not supplied',        'sanger contact not supplied';
is $head_error->[2]->description, 'sequencing technology not supplied', 'sequencing technology not supplied';
is $head_error->[3]->description, 'study name not supplied',            'study name not supplied';
is $head_error->[4]->description, 'non-word in study accession number', 'non-word in study accession number';

# warnings from header
my $head_warning = $validator->header_warning_list;
is $head_warning->[0]->description, 'supplier name not supplied', 'supplier name not supplied';
is $head_warning->[1]->description, 'file size not supplied',     'file size not supplied';
is $head_warning->[2]->description, 'date not supplied',          'date not supplied';

# errors from expt
my $expt_error   = $validator->rows_error_list;
is $expt_error->[0]->description, 'experiment filename not unique',   'experiment filename not unique';
is $expt_error->[1]->description, 'experiment filename not unique',   'experiment filename not unique';
is $expt_error->[2]->description, 'experiment filename not supplied', 'experiment filename not supplied';
is $expt_error->[3]->description, 'sample name not supplied',         'sample name not supplied';
is $expt_error->[4]->description, 'sample accession not recognised',  'sample accession not recognised';
is $expt_error->[5]->description, 'taxon id not supplied',            'taxon id not supplied';
is $expt_error->[6]->description, 'library name not supplied',        'library name not supplied';

# warnings from expt
my $expt_warning = $validator->rows_warning_list;
is $expt_warning->[0]->description, 'fragment size not supplied', 'fragment size not supplied';
is $expt_warning->[1]->description, 'read count not supplied',    'read count not supplied';
is $expt_warning->[2]->description, 'base count not supplied',    'base count not supplied';

# total errors
is $validator->total_errors_found, 12, 'total errors';

done_testing();