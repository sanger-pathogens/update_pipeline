#!/usr/bin/env perl
use strict;
use warnings;



BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most;
  use_ok('UpdatePipeline::Spreadsheet::SequencingFiles');
}

ok my $valid_sequencing_file = UpdatePipeline::Spreadsheet::SequencingFiles->new(
  filename             => 'myfile.fastq.gz',
  files_base_directory => 't/data'
), 'initialise finding file on disk';
is $valid_sequencing_file->find_file_on_disk, 't/data/path/to/sequencing/myfile.fastq.gz';

ok my $invalid_sequencing_file = UpdatePipeline::Spreadsheet::SequencingFiles->new(
  filename             => 'non_existant_file.fastq.gz',
  files_base_directory => 't/data'
), 'initialise finding file on disk with non existant file';
is $invalid_sequencing_file->find_file_on_disk, undef, 'non existant file returns undef';

throws_ok(  sub { UpdatePipeline::Spreadsheet::SequencingFiles->new(
  filename             => 'myfile.fastq.gz',
  files_base_directory => 't/data/some_non_existant_directory')}, qr/directory doesnt exist/, 'Directory that doesnt exist throws an error');

done_testing();
