#!/usr/bin/env perl

=head1 NAME
=head1 SYNOPSIS
=head1 DESCRIPTION
=head1 CONTACT
=head1 METHODS

=cut

BEGIN { unshift(@INC, './modules') }
use strict;
use warnings;
use UpdatePipeline::IRODS;


my $update_pipeline_irods = UpdatePipeline::IRODS->new(
  study_names => ['Streptococcus equi genome diversity'],
  environment => 'test',
  );
$update_pipeline_irods->print_file_metadata();