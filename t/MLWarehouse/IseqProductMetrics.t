#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('MLWarehouse::IseqProductMetrics');
    use MLWarehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = MLWarehouse::Database->new( settings => $database_settings->{ml_warehouse} )->connect;

# Multiplexed sample
delete_test_data($dbh);
$dbh->do(
'insert into iseq_product_metrics (id_run,position,tag_index,insert_size_median) values(123, 4, 345, 500)'
);

##### lookup with no groups
ok( my $obj = UpdatePipeline::FileMetaData->new( file_name => '123_4#345.bam', file_name_without_extension => '123_4#345' ),
    'Created file metadata with no insert size' );
is( $obj->fragment_size_from, undef, 'fragment_size_from should be undef to begin with' );
is( $obj->fragment_size_to,   undef, 'fragment_size_to should be undef to begin with' );
ok( my $iseq_obj = MLWarehouse::IseqProductMetrics->new( file_meta_data => $obj, _dbh => $dbh ),
    'initialise warehouse IseqProductMetrics object with file metadata' );
ok( $iseq_obj->populate(), 'populate file metadata' );
is( $obj->fragment_size_from, 500, 'fragment_size_from should be set' );
is( $obj->fragment_size_to,   500, 'fragment_size_to should be set' );

delete_test_data($dbh);
done_testing();

sub delete_test_data {
    my $vrtrack = shift;
    $dbh->do('delete from iseq_product_metrics where id_run=123');
}