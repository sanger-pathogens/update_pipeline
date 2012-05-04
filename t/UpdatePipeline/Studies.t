#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::Studies');
}

ok my $study_names_obj = UpdatePipeline::Studies->new(filename => 't/data/study_name_list'), 'initialise study name object';
my @expected_study_list  = ("A Study","Another Study with a longer title");
is_deeply $study_names_obj->study_names, \@expected_study_list, 'study names extracted correctly';

done_testing();
