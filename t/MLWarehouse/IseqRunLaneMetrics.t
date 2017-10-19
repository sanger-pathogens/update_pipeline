#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('MLWarehouse::IseqRunLaneMetrics');
    use MLWarehouse::Database;
    use Pathogens::ConfigSettings;
    use UpdatePipeline::FileMetaData;
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = MLWarehouse::Database->new( settings => $database_settings->{ml_warehouse} )->connect;

# run_date
delete_test_data($dbh);
$dbh->do(
'insert into iseq_run_lane_metrics (id_run,position,paired_read, cycles, run_complete) values(123, 4, 1, 100, "2008-04-01 18:39:44")'
);

##### lookup with no groups
ok(  my $obj = UpdatePipeline::FileMetaData->new( file_name => '123_4#3456.bam', file_name_without_extension => '123_4#3456' ),
    'Created file metadata with no insert size' );
is( $obj->run_date, undef, 'run_date should be undef to begin with' );
ok( my $iseq_obj = MLWarehouse::IseqRunLaneMetrics->new( file_meta_data => $obj, _dbh => $dbh ),
    'initialise warehouse IseqProductMetrics object with file metadata' );
ok( $iseq_obj->populate(), 'populate file metadata' );
is( $obj->run_date, "2008-04-01 18:39:44", 'run_date should be set' );

delete_test_data($dbh);
done_testing();

sub delete_test_data {
    my $vrtrack = shift;
    $dbh->do('delete from iseq_run_lane_metrics where id_run=123');
}