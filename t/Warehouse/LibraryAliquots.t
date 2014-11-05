#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Warehouse::LibraryAliquots');
    use Warehouse::Database;
    use Pathogens::ConfigSettings;
}

# connect to the test warehouse database
my $database_settings = Pathogens::ConfigSettings->new( environment => 'test', filename => 'database.yml' )->settings();
my $dbh = Warehouse::Database->new( settings => $database_settings->{warehouse} )->connect;

delete_test_data($dbh);
$dbh->do(
    'insert into current_studies  (name,internal_id,accession_number,is_current) values("ABC study",1111,"EFG123",1)');
$dbh->do(
'insert into current_aliquots (sample_internal_id,receptacle_internal_id,study_internal_id,receptacle_type,is_current) values(2222,3333,1111,"pac_bio_library_tube",1)'
);
$dbh->do(
'insert into current_samples (name,accession_number,common_name, supplier_name,internal_id,is_current) values("ABC sample","HIJ456","Sample common name","Sample supplier name",2222,1)'
);

ok(
    my $study_doesnt_exist_obj = Warehouse::LibraryAliquots->new(
        _dbh       => $dbh,
        study_name => 'Study that doesnt exist',
    ),
    'Initialise study that doesnt exist'
);
is_deeply( [], $study_doesnt_exist_obj->libraries_metadata(), 'nothing should be returned if the study doesnt exist' );

ok(
    my $study_with_one_library_obj = Warehouse::LibraryAliquots->new(
        _dbh       => $dbh,
        study_name => 'ABC study',
    ),
    'Initialise study with one library'
);
is_deeply(
    [
        bless(
            {
                'supplier_name'           => 'Sample supplier name',
                'study_name'              => 'ABC study',
                'sample_name'             => 'ABC sample',
            },
            'UpdatePipeline::LibraryMetaData'
        )
    ],
    $study_with_one_library_obj->libraries_metadata(),
    'one library meta data obj should be created'
);

delete_test_data($dbh);
done_testing();

sub delete_test_data {
    my $vrtrack = shift;
    $dbh->do('delete from current_studies where name="ABC study"');
    $dbh->do('delete from current_aliquots where sample_internal_id=2222');
    $dbh->do('delete from current_samples where name="ABC sample"');
    $dbh->do('delete from current_pac_bio_library_tubes where name="Library name"');
}
