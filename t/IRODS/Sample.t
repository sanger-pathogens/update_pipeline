#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('IRODS::Sample');
}

# pass in a valid file location
ok my $sample = IRODS::Sample->new( name => 'My Sample', file_containing_irods_output => 't/data/irods_sample_file_list'), 'Initialise valid file location';
my $expected_output = [
          '/seq/pacbio/25431_647/A01_1/Analysis_Results/m140124_184447_00127_c100569562550000001823092801191475_s1_X0.1.bax.h5',
          '/seq/pacbio/25431_647/A01_1/Analysis_Results/m140124_184447_00127_c100569562550000001823092801191475_s1_X0.2.bax.h5',
          '/seq/pacbio/25431_647/A01_1/Analysis_Results/m140124_184447_00127_c100569562550000001823092801191475_s1_X0.3.bax.h5',
          '/seq/pacbio/25431_647/A01_1/Analysis_Results/m140124_184447_00127_c100569562550000001823092801191475_s1_X0.bas.h5',
          '/seq/pacbio/25466_648/A01_1/Analysis_Results/m140127_171504_00127_c100584662550000001823103604281470_s1_p0.1.bax.h5',
          '/seq/pacbio/25466_648/A01_1/Analysis_Results/m140127_171504_00127_c100584662550000001823103604281470_s1_p0.2.bax.h5',
          '/seq/pacbio/25466_648/A01_1/Analysis_Results/m140127_171504_00127_c100584662550000001823103604281470_s1_p0.3.bax.h5',
          '/seq/pacbio/25466_648/A01_1/Analysis_Results/m140127_171504_00127_c100584662550000001823103604281470_s1_p0.bas.h5',
          '/seq/pacbio/25466_648/A01_2/Analysis_Results/m140127_203356_00127_c100584662550000001823103604281471_s1_p0.1.bax.h5',
          '/seq/pacbio/25466_648/A01_2/Analysis_Results/m140127_203356_00127_c100584662550000001823103604281471_s1_p0.2.bax.h5',
          '/seq/pacbio/25466_648/A01_2/Analysis_Results/m140127_203356_00127_c100584662550000001823103604281471_s1_p0.3.bax.h5',
          '/seq/pacbio/25466_648/A01_2/Analysis_Results/m140127_203356_00127_c100584662550000001823103604281471_s1_p0.bas.h5'
        ];
is_deeply $sample->file_locations(), $expected_output, "parsed valid irods file";

# Invalid stream
ok my $invalid_sample = IRODS::Sample->new( name => 'My Sample', file_containing_irods_output => 't/data/file_that_doesnt_exist'), 'Initialise invalid stream';
my @expected_invalid_output = ();
is_deeply $invalid_sample->file_locations(), \@expected_invalid_output, "Invalid stream should return empty array";

done_testing();