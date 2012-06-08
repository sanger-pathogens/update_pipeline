#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 9;
    use_ok('IRODS::File');
}

my $id_run_selected = 999;

# pass in a valid file location
ok my $file = IRODS::File->new( file_location => "/seq/2442/2442_6#123.bam", file_containing_irods_output => 't/data/irods_file_metadata'), 'Initialise valid file metadata location';
my %expected_output = (
  md5 => '123456789abcdef',
  type => 'bam',
  alignment => '0',
  library_id => '123456',
  sample_accession_number => 'ABC0000123',
  id_run => '999',
  total_reads => '100200300',
  lane => '7',
  sample => 'AB_CD_EF',
  study_title => 'Test study title',
  target => '1',
  study => 'Test study title',
  library => 'AB_CD_EF 1',
  study_accession_number => 'ABC123',
  file_name => '2442_6#123.bam',
  file_name_without_extension => '2442_6#123',
  is_paired_read => 1,
  manual_qc => 'pass',
  sample_common_name => 'Shigella flexneri',
  study_id   => 55555,
  sample_id => 44444,
);
is_deeply $file->file_attributes(), \%expected_output, "parsed valid irods file";


# Invalid stream
ok my $invalid_file = IRODS::File->new( file_location => "/seq/2442/2442_6.bam", file_containing_irods_output => 't/data/file_that_doesnt_exist'), 'Initialise invalid stream';
my %expected_invalid_output = ( file_name => '2442_6.bam', file_name_without_extension => '2442_6');
is_deeply $invalid_file->file_attributes(), \%expected_invalid_output, "Invalid stream should return empty array";

# strip non human
# pass in a valid file location
ok  $file = IRODS::File->new( file_location => "/seq/2442/2442_6_nonhuman#123.bam", file_containing_irods_output => 't/data/irods_file_metadata'), 'Initialise valid file metadata location with nonhuman';
my %expected_output2 = (
  md5 => '123456789abcdef',
  type => 'bam',
  alignment => '0',
  library_id => '123456',
  sample_accession_number => 'ABC0000123',
  id_run => '999',
  total_reads => '100200300',
  lane => '7',
  sample => 'AB_CD_EF',
  study_title => 'Test study title',
  target => '1',
  study => 'Test study title',
  library => 'AB_CD_EF 1',
  study_accession_number => 'ABC123',
  file_name => '2442_6_nonhuman#123.bam',
  file_name_without_extension => '2442_6#123',
  is_paired_read => 1,
  manual_qc => 'pass',
  sample_common_name => 'Shigella flexneri',
  study_id   => 55555,
  sample_id => 44444,
);
is_deeply $file->file_attributes(), \%expected_output2, "parsed valid irods file with non human";

# retrieve md5 if missing from bam metadata
ok $file = IRODS::File->new( file_location => "/seq/7434/7434_6#82.bam", file_containing_irods_output => 't/data/irods_file_metadata_no_md5'), 'Initialise with valid file that has md5 missing from metadata';
my %expected_output3 = (
  md5 => '5af75053efd18b7f26e874b5e553bde0',
  type => 'bam',
  alignment => '1',
  library_id => '4202230',
  sample_accession_number => 'EGAN00001029367',
  id_run => '7434',
  total_reads => '154906330',
  lane => '6',
  sample => 'VBSEQ5231072',
  target => '1',
  library => '4202230',
  study_title => 'WGS of Borbera genetic isolate',
  file_name => '7434_6#82.bam',
  file_name_without_extension => '7434_6#82',
  is_paired_read => 1,
  manual_qc => 'pass',
  sample_common_name => 'Homo Sapien',
  study_id   => 1948,
  sample_id => 1283434,
);
is_deeply $file->file_attributes(), \%expected_output3, "obtained md5 from iRODS icat using ichksum";

is $expected_output{id_run}, $id_run_selected, 'id_run matches that specified so would be updated in db';
is $expected_output{id_run}, $id_run_selected, 'id_run matches that specified so would be updated in db';
isnt $expected_output3{id_run}, $id_run_selected, 'id_run does not match that specified so would be rejected';