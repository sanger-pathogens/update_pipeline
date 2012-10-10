#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::Validate::SequencingExperiments');
}

my @valid_rows = (
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => undef,
    sample_name             => '1',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'L5_AB_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 316211200,
    comments                => undef
  },
  {
    filename                => 'myotherfile_L3.fastq.gz', 
    mate_filename           => 'mymate_file.fastq.gz',
    sample_name             => '2',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'EF_CD_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 135104205,
    comments                => undef
  },
  {
    filename                => 'yetanotherfile_L4.fastq.gz', 
    mate_filename           => undef,
    sample_name             => '3',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'ABC45678',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 177773050,
    comments                => undef
  },
);

ok my $valid_sequencing_experiments_obj = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => \@valid_rows);
is $valid_sequencing_experiments_obj->is_valid, 1, 'input is valid';


my @missing_file_name = (
  {
    filename                => undef, 
    mate_filename           => undef,
    sample_name             => '1',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'L5_AB_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 316211200,
    comments                => undef
  }
);

ok my $invalid_sequencing_experiments_obj = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => \@missing_file_name);
is $invalid_sequencing_experiments_obj->is_valid, 0, 'input is invalid without a filename';


my @taxon_id_not_a_number = (
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => undef,
    sample_name             => '1',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'L5_AB_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 316211200,
    comments                => undef
  },
  {
    filename                => 'myotherfile_L3.fastq.gz', 
    mate_filename           => 'mymate_file.fastq.gz',
    sample_name             => '2',
    sample_accession_number => undef,
    taxon_id                => 'something thats not a number',
    library_name            => 'EF_CD_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 135104205,
    comments                => undef
  },
  {
    filename                => 'yetanotherfile_L4.fastq.gz', 
    mate_filename           => undef,
    sample_name             => '3',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'ABC45678',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 177773050,
    comments                => undef
  },
);

ok my $invalid_taxon_id_not_int = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => \@taxon_id_not_a_number);
is $invalid_taxon_id_not_int->is_valid, 0, 'taxon_id is not an int';

my @missing_sample_name = (
  {
    filename                => 'abc', 
    mate_filename           => undef,
    sample_name             => undef,
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'L5_AB_12_2011',
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 316211200,
    comments                => undef
  }
);

ok my $invalid_missing_sample_name = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => \@missing_sample_name);
is $invalid_missing_sample_name->is_valid, 0, 'input is invalid without a sample name';

my @missing_library_name = (
  {
    filename                => 'abc', 
    mate_filename           => undef,
    sample_name             => 'efg',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => undef,
    fragment_size             => 200,
    raw_read_count          => undef,
    raw_base_count          => 316211200,
    comments                => undef
  }
);

ok my $invalid_missing_library_name = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => \@missing_library_name);
is $invalid_missing_library_name->is_valid, 0, 'input is invalid without a library name';




done_testing();
