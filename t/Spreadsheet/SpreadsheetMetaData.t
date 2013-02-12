#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::MockObject;


BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most;
  use_ok('UpdatePipeline::Spreadsheet::SpreadsheetMetaData');
  use UpdatePipeline::FileMetaData;
  
  my $ncbi_taxon_lookup = Test::MockObject->new();
  $ncbi_taxon_lookup->fake_module( 'NCBI::TaxonLookup', test => sub{1} );
  $ncbi_taxon_lookup->fake_new( 'NCBI::TaxonLookup' );
  $ncbi_taxon_lookup->mock('common_name', sub{ 'SomeCommonName' });
}

my @raw_rows = (
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => 'mymate.fastq.gz',
    sample_name             => '1',
    sample_accession_number => 'XYZ',
    taxon_id                => 9606,
    library_name            => 'L5_AB_12_2011',
    fragment_size             => 200,
    raw_read_count          => 123456,
    raw_base_count          => 316211200,
    comments                => undef
  },
  {
    filename                => 'myotherfile_L3.fastq.gz', 
    mate_filename           => undef,
    sample_name             => '2',
    sample_accession_number => undef,
    taxon_id                => 589363,
    library_name            => 'EF_CD_12_2011',
    fragment_size             => undef,
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

ok my $valid_spreadsheet = UpdatePipeline::Spreadsheet::SpreadsheetMetaData->new(
    input_header => {
      supplier_name                  => 'John Doe',
      supplier_organisation          => 'Somewhere',
      internal_contact               => 'Jane Doe',
      sequencing_technology          => 'Illumina',
      study_name                     => 'My Study Name',
      study_accession_number         => 'ERS123',
      total_size_of_files_in_gbytes  => '2.2',
      data_to_be_kept_until          => '2013-01-23',
    },
    raw_rows => \@raw_rows,
    
  ), 'valid spreadsheet';
  
is $valid_spreadsheet->_header->supplier_name, 'John Doe', 'Header parsed and loaded correctly';
my @sequencing_experiments_array = @{$valid_spreadsheet->_sequencing_experiments};
is $sequencing_experiments_array[0]->filename,'myfile.fastq.gz',  'Rows parsed correctly';
is $sequencing_experiments_array[2]->filename,'yetanotherfile_L4.fastq.gz', 'Rows parsed correctly';

my $expected_file_metadata_mate_pair = UpdatePipeline::FileMetaData->new(
         mate_file_type                    => 'fastq.gz',
         library_name                      => 'L5_AB_12_2011',
         lane_manual_qc                    => '-',
         total_reads                       => 123456,
         mate_file_name_without_extension  => 'myfile_2',
         file_type                         => 'fastq.gz',
         sample_common_name                => 'SomeCommonName',
         study_accession_number            => 'ERS123',
         lane_is_paired_read               => 1,
         study_name                        => 'My Study Name',
         file_name                         => 'myfile_1.fastq.gz',
         sample_name                       => '1',
         sample_accession_number           => 'XYZ',
         file_name_without_extension       => 'myfile_1',
         mate_file_name                    => 'myfile_2.fastq.gz',
         fragment_size_from                => 200,
         fragment_size_to                  => 200,
);
       
my $expected_file_metadata_single_ended = UpdatePipeline::FileMetaData->new(
         library_name                      => 'EF_CD_12_2011',
         lane_manual_qc                    => '-',
         total_reads                       => undef,
         file_type                         => 'fastq.gz',
         sample_common_name                => 'SomeCommonName',
         study_accession_number            => 'ERS123',
         lane_is_paired_read               => 0,
         study_name                        => 'My Study Name',
         file_name                         => 'myotherfile_L3_1.fastq.gz',
         sample_name                       => '2',
         sample_accession_number           => undef,
         file_name_without_extension       => 'myotherfile_L3_1',
         fragment_size_from                => undef,
         fragment_size_to                  => undef,
         mate_file_name_without_extension  => undef,
         mate_file_name                    => undef,
         mate_file_type                    => undef,
);

my @files_metadata = @{$valid_spreadsheet->files_metadata};
is_deeply $files_metadata[0],$expected_file_metadata_mate_pair, 'generated filemetadata is correct';
is_deeply $files_metadata[1],$expected_file_metadata_single_ended, 'single ended filemetadata correct';


done_testing();