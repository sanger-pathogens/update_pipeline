#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Spreadsheet::Validate::Header');
}

ok my $valid_header_obj = UpdatePipeline::Spreadsheet::Validate::Header->new(
    input_header => {
      supplier_name                  => 'John Doe',
      supplier_organisation          => 'Somewhere',
      internal_contact               => 'Jane Doe',
      sequencing_technology          => 'Illumina',
      study_name                     => 'My Study Name',
      study_accession_number         => 'ERS123',
      total_size_of_files_in_gbytes  => '2.2',
      data_to_be_kept_until          => '2013-01-23',
    }
  );
is $valid_header_obj->is_valid, 1, 'input is valid';


ok my $invalid_missing_supplier_name = UpdatePipeline::Spreadsheet::Validate::Header->new(
    input_header => {
      supplier_name                  => undef,
      supplier_organisation          => 'Somewhere',
      internal_contact               => 'Jane Doe',
      sequencing_technology          => 'Illumina',
      study_name                     => 'My Study Name',
      study_accession_number         => 'ERS123',
      total_size_of_files_in_gbytes  => '2.2',
      data_to_be_kept_until          => '2013-01-23',
      }
  );
is $invalid_missing_supplier_name->is_valid, 0, 'invalid_missing_supplier_name ';


ok my $invalid_missing_organisation = UpdatePipeline::Spreadsheet::Validate::Header->new(
    input_header => {
      supplier_name                  => 'John Doe',
      supplier_organisation          => undef,
      internal_contact               => 'Jane Doe',
      sequencing_technology          => 'Illumina',
      study_name                     => 'My Study Name',
      study_accession_number         => 'ERS123',
      total_size_of_files_in_gbytes  => '2.2',
      data_to_be_kept_until          => '2013-01-23',
      }
  );
is $invalid_missing_organisation->is_valid, 0, 'invalid_missing_organisation';


ok my $invalid_missing_seq_tech = UpdatePipeline::Spreadsheet::Validate::Header->new(
    input_header => {
      supplier_name                  => 'John Doe',
      supplier_organisation          => 'Somewhere',
      internal_contact               => 'Jane Doe',
      sequencing_technology          => undef,
      study_name                     => 'My Study Name',
      study_accession_number         => 'ERS123',
      total_size_of_files_in_gbytes  => '2.2',
      data_to_be_kept_until          => '2013-01-23',
      }
  );
is $invalid_missing_seq_tech->is_valid, 0, 'invalid_missing_seq_tech';

done_testing();
