#!/usr/bin/env perl
use strict;
use warnings;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most tests => 1;
    use_ok('UpdatePipeline::VRTrack::Project');
}



