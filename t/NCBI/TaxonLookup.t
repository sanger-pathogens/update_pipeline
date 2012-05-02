#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('NCBI::TaxonLookup');
}

ok my $taxon_lookup = NCBI::TaxonLookup->new(
  taxon_id => 9606, 
  taxon_lookup_service => 't/data/ncbi_lookup_taxon_'
);
is $taxon_lookup->common_name, 'Homo sapiens', 'correctly looked up the common name';

done_testing();
