#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most;
  use_ok('UpdatePipeline::Spreadsheet::SequencingExperimentMetaData');
}

my @rows = (
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => undef,
    sample_name             => 'valid_file',
    taxon_id                => 1,
    library_name            => '1',
  },
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => 'mymate_file.fastq.gz',
    sample_name             => 'valid pair of files',
    taxon_id                => 1,
    library_name            => '1',
  },
  {
    filename                => 'myfile.fastq.gz', 
    mate_filename           => 'nonexistantfile',
    sample_name             => 'invalid file',
    taxon_id                => 1,
    library_name            => '1',
  }
);


ok my $sequencing_experiment = UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new($rows[0]), 'initialise sequencing experiment';
ok $sequencing_experiment->populate_file_locations_on_disk('t/data'),'lookup file locations';
is $sequencing_experiment->file_location_on_disk,'t/data/path/to/sequencing/myfile.fastq.gz','primary file found';
is $sequencing_experiment->mate_file_location_on_disk, undef,'mate file not found';
is $sequencing_experiment->pipeline_filename, 'myfile_1.fastq.gz','converted filename';

ok my $valid_pair = UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new($rows[1]), 'initialise sequencing experiment';
ok $valid_pair->populate_file_locations_on_disk('t/data'),'lookup file locations';
is $valid_pair->file_location_on_disk,'t/data/path/to/sequencing/myfile.fastq.gz','primary file found';
is $valid_pair->mate_file_location_on_disk,'t/data/path/to/sequencing/mymate_file.fastq.gz','mate file found';
is $valid_pair->pipeline_filename, 'myfile_1.fastq.gz','converted filename';
is $valid_pair->pipeline_mate_filename, 'myfile_2.fastq.gz','converted mate filename';

ok my $nonexistantfile = UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new($rows[2]), 'initialise sequencing experiment';
throws_ok( sub{ $nonexistantfile->populate_file_locations_on_disk('t/data') },qr/Cant find file/,'file that cant be found throws an error');


done_testing();
