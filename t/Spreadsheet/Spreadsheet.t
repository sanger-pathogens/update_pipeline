#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use Test::MockObject;


BEGIN { unshift(@INC, './modules') }
BEGIN {
  use Test::Most;
  use_ok('UpdatePipeline::Spreadsheet');
  
  my $ncbi_taxon_lookup = Test::MockObject->new();
  $ncbi_taxon_lookup->fake_module( 'NCBI::TaxonLookup', test => sub{1} );
  $ncbi_taxon_lookup->fake_new( 'NCBI::TaxonLookup' );
  $ncbi_taxon_lookup->mock('common_name', sub{ 'SomeCommonName' });
}

ok my $spreadsheet = UpdatePipeline::Spreadsheet->new(
  filename => 't/data/external_data_example.xls'
), 'initialise spreadsheet driver class';
ok $spreadsheet->files_metadata, 'generate the files metadata';

is $spreadsheet->files_metadata->[0]->file_name,'myfile.fastq.gz', 'filename returned correctly';

done_testing();
