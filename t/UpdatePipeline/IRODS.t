#!/usr/bin/env perl
use strict;
use warnings;
use Test::MockObject;
use Data::Dumper;

# mock the call to the IRODS::Study
my $irods_study = Test::MockObject->new();
$irods_study->fake_module( 'IRODS::Study', test => sub{1} );
$irods_study->fake_new( 'IRODS::Study' );
my @study_file_locations = ("/seq/2442/2442_5.bam","/seq/2442/2442_6.bam","/seq/2657/2657_1.bam","/seq/2787/2787_3.bam");
$irods_study->mock('file_locations', sub{ \@study_file_locations });

# mock the call to IRODS::File
my $irods_file = Test::MockObject->new();
$irods_file->fake_module( 'IRODS::File', test => sub{1} );
$irods_file->fake_new('IRODS::File');
my %irods_file_expected_output = (
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
  study_accession_number => 'ABC123'
);
$irods_file->mock('file_attributes', sub{ \%irods_file_expected_output });


BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most tests => 5;
  
  my $irods_study = Test::MockObject->new();
  $irods_study->fake_new( 'IRODS::Study' );
  $irods_study->fake_module( 'IRODS::Study', test => sub{1} );
  
  use_ok('UpdatePipeline::IRODS');
}

my @study_names = ("MyStudy");
ok my $update_pipelines_irods = UpdatePipeline::IRODS->new( study_names => \@study_names, _warehouse_dbh => "abc"), 'Initialise valid irods study names';
is_deeply @{$update_pipelines_irods->_irods_studies}[0]->file_locations, \@study_file_locations, 'valid get back list of file locations for study';

is_deeply @{$update_pipelines_irods->_get_irods_file_metadata_for_studies}[0], \%irods_file_expected_output, 'valid file metadata returned';

# check runs are sorted okay
my @unsorted_runs = ('/seq/2002/2002_5.bam','/seq/2002/2002_6#2.bam','/seq/2009/2009_1.bam','/seq/1001/1001_1.bam');
my @expected_sorting= ("/seq/2009/2009_1.bam","/seq/2002/2002_6#2.bam","/seq/2002/2002_5.bam","/seq/1001/1001_1.bam");

my @actual_sorting = (sort sort_by_id_run @unsorted_runs);
is_deeply \@expected_sorting,\@actual_sorting, 'sorting by id run works okay';

# Fixme: shouldnt be here at all but cant get the module calling correctly
sub sort_by_id_run
{
  my @a = split(/\//,$a);
  my @b = split(/\//,$b);

  $b[2]<=>$a[2] || $b[3] cmp $a[3];
}



