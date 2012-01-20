#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 4;
    use_ok('UpdatePipeline::Common');
}

my @array_with_duplicate_undefs = (undef, undef, undef);
my @array_with_no_duplicates = ("abc",10,"efg",9,undef);
my @array_with_one_value = (undef, undef, undef,undef, "abc", undef);


# check undef
is UpdatePipeline::Common::array_contains_value(@array_with_duplicate_undefs ), 0, 'array contains no values';

# check duplicates are removed when there is text
is UpdatePipeline::Common::array_contains_value(@array_with_no_duplicates ), 1, 'array contains values';

is UpdatePipeline::Common::array_contains_value(@array_with_one_value ), 1, 'array contain one value in the middle of undefs';

