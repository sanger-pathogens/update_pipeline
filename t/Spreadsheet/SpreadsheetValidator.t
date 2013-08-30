#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetValidatator');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header');
    use_ok('UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment');
}

# copy stdout and redirect stdout
my $stdout;
open(my $copy_stdout, ">&STDOUT");
close(STDOUT); open(STDOUT, ">", \$stdout);

# check validator
ok my $validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator->new(filename => 't/data/external_data_example.xls'), 'open example spreadsheet';
ok $validator->validate(), 'example spreadsheet is valid';

throws_ok(sub { UpdatePipeline::Spreadsheet::SpreadsheetValidatator->new(filename => 'file_that_does_not_exist') } , qr/file does not exist/, 'parsing non-existent file throws an error');
close(STDOUT); $stdout = ''; open(STDOUT, ">", \$stdout);


# check header
my $header_in = { supplier_name                  => 'name',
		  supplier_organisation          => 'organisation',
		  internal_contact               => 'contact',
		  sequencing_technology          => 'Illumina',
		  study_name                     => 'study',
		  study_accession_number         => '1234',
		  total_size_of_files_in_gbytes  => '1.23',
		  data_to_be_kept_until          => '01.02.1234'};

ok my $header_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header->new( header => $header_in );

ok my $header_out = $header_validator->valid_header();

my $expected_stdout = qq[Supplier Name          is string    ok
Supplier Organisation  is string    ok
Sanger Contact Name    is string    ok
Sequencing Technology  is string    ok
Study Name             is string    ok
Study Accession Number is integer   ok
Size of files (GBytes) is number    ok
Data retained until    is date      ok
];

is $stdout, $expected_stdout, 'got expected output';
is_deeply $header_out, $header_in, 'valid header returned';
close(STDOUT); $stdout = ''; open(STDOUT, ">", \$stdout);


$header_in       = { supplier_name                  => undef,
		     supplier_organisation          => undef,
		     internal_contact               => undef,
		     sequencing_technology          => 'magic',
		     study_name                     => undef,
		     study_accession_number         => 'abc',
		     total_size_of_files_in_gbytes  => 'lots',
		     data_to_be_kept_until          => 'end of time' };

my $expected_out = { supplier_name                  => '',
		     supplier_organisation          => '',
		     internal_contact               => '',
		     sequencing_technology          => 'Illumina',
		     study_name                     => undef,
		     study_accession_number         => undef,
		     total_size_of_files_in_gbytes  => 'lots',
		     data_to_be_kept_until          => 'end of time' };

ok $header_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header->new( header => $header_in );
ok $header_out = $header_validator->valid_header();

$expected_stdout = qq[Supplier Name          is undefined error
 setting supplier name to empty string
Supplier Organisation  is undefined error
 setting supplier name to empty string
Sanger Contact Name    is undefined error
 setting internal contact to empty string
Sequencing Technology  is string    ok
 error: sequencing technology 'magic' not recognised.
 setting sequencing technology to default, 'Illumina'
Study Name             is undefined error
 fatal error: study name not supplied
Study Accession Number is string    error
 setting study accession to undef
Size of files (GBytes) is string    error
Data retained until    is string    error
];
is $stdout, $expected_stdout, 'got expected output';
is_deeply $header_out, $expected_out, 'corrected header returned';
close(STDOUT); $stdout = ''; open(STDOUT, ">", \$stdout);

# check sequencing experiment metadata
my $expt_row_in = { filename                => 'file', 
		    mate_filename           => 'mate',
		    sample_name             => 'abc',
		    sample_accession_number => 'ERS123',
		    taxon_id                => 12345,
		    library_name            => 'def',
		    fragment_size           => 100,
		    raw_read_count          => 200,
		    raw_base_count          => 20000,
		    comments                => 'first we take manhattan...' };

ok my $row_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment->new( experiment_row => $expt_row_in );
ok my $expt_row_out = $row_validator->valid_experiment_row();

$expected_stdout = qq[
file
Filename               is string    ok
Mate Filename          is string    ok
Sample Name            is string    ok
Sample Accession       is string    ok
Taxon ID               is integer   ok
Library Name           is string    ok
Fragment Size          is integer   ok
Read Count             is integer   ok
Base Count             is integer   ok
Comments               is string    ok
];

is $stdout, $expected_stdout, 'got expected output';
is_deeply $expt_row_out, $expt_row_in, 'valid row returned';
close(STDOUT); $stdout = ''; open(STDOUT, ">", \$stdout);


$expt_row_in         = { filename                => '/path/to/file', 
			 mate_filename           => undef,
			 sample_name             => undef,
			 sample_accession_number => ' ',
			 taxon_id                => 'ecoli',
			 library_name            => undef,
			 fragment_size           => '100bp',
			 raw_read_count          => 'lots',
			 raw_base_count          => 'lots',
			 comments                => 'then we take berlin' };

my $expected_row_out = { filename                => 'file', 
			 mate_filename           => undef,
			 sample_name             => undef,
			 sample_accession_number => undef,
			 taxon_id                => undef,
			 library_name            => undef,
			 fragment_size           => 100,
			 raw_read_count          => undef,
			 raw_base_count          => undef,
			 comments                => 'then we take berlin' };

ok $row_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment->new( experiment_row => $expt_row_in );
ok $expt_row_out = $row_validator->valid_experiment_row();

$expected_stdout = qq[
/path/to/file
Filename               is string    ok
 removing path from '/path/to/file'
 Filename is 'file'
Mate Filename          is undefined ok
Sample Name            is undefined error
 fatal error: sample name not present.
Sample Accession       is blank     error
Taxon ID               is string    error
 fatal error: taxon id is not an integer.
Library Name           is undefined error
 fatal error: library name not present.
Fragment Size          is string    error
 fragment size is 100bp - fragment size set to 100
Read Count             is string    error
Base Count             is string    error
Comments               is string    ok
];

is $stdout, $expected_stdout, 'got expected output';
is_deeply $expt_row_out, $expected_row_out, 'corrected row returned';


# restore stdout
close(STDOUT); open(STDOUT, ">&", $copy_stdout); # restore stdout

done_testing();
