#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 5;
    use_ok('IRODS::Study');
}

# pass in a valid file location
ok my $study = IRODS::Study->new( name => 'My Study', file_containing_irods_output => 't/data/irods_study_file_list'), 'Initialise valid file location';
my @expected_output = ("/seq/2442/2442_5.bam","/seq/2442/2442_6.bam","/seq/2657/2657_1.bam","/seq/2787/2787_3.bam");
is_deeply $study->file_locations(), \@expected_output, "parsed valid irods file";

# Invalid stream
ok my $invalid_study = IRODS::Study->new( name => 'My Study', file_containing_irods_output => 't/data/file_that_doesnt_exist'), 'Initialise invalid stream';
my @expected_invalid_output = ();
is_deeply $invalid_study->file_locations(), \@expected_invalid_output, "Invalid stream should return empty array";

