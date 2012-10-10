#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::Parser');
}

# takes in a spreadsheet, outputs

ok my $valid_spreadsheet = UpdatePipeline::Spreadsheet::Parser->new(
    filename => 't/data/external_data_example.xls'
  ), 'valid spreadsheet';

my %expected_header = (
  supplier_name                  => 'John Doe',
  supplier_organisation          => 'Somewhere',
  internal_contact               => 'Jane Doe',
  sequencing_technology          => 'Illumina',
  study_name                     => 'My Study Name',
  study_accession_number         => 'ERS123',
  total_size_of_files_in_gbytes  => '2.2',
  data_to_be_kept_until          => '2013-01-23',
);

is_deeply  $valid_spreadsheet->header_metadata, \%expected_header, 'header parsed correctly';

my @expected_rows = (
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

is_deeply  $valid_spreadsheet->rows_metadata, \@expected_rows, 'rows metadata parsed';

throws_ok(sub { UpdatePipeline::Spreadsheet::Parser->new(filename => 'file_that_doesnt_exist') } , qr/file does not exist/, 'File that doesnt exist throws an error');


done_testing();
