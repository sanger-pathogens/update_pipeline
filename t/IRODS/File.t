#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 7;
    use_ok('IRODS::File');
}

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
);
is_deeply $file->file_attributes(), \%expected_output, "parsed valid irods file";



# Invalid stream
ok my $invalid_file = IRODS::File->new( file_location => "/seq/2442/2442_6.bam", file_containing_irods_output => 't/data/file_that_doesnt_exist'), 'Initialise invalid stream';
my %expected_invalid_output = ( file_name => '2442_6.bam', file_name_without_extension => '2442_6');
is_deeply $invalid_file->file_attributes(), \%expected_invalid_output, "Invalid stream should return empty array";

# strip non human
# pass in a valid file location
ok  $file = IRODS::File->new( file_location => "/seq/2442/2442_6_nonhuman#123.bam", file_containing_irods_output => 't/data/irods_file_metadata'), 'Initialise valid file metadata location with nonhuman';
 %expected_output = (
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
);
is_deeply $file->file_attributes(), \%expected_output, "parsed valid irods file with non human";

