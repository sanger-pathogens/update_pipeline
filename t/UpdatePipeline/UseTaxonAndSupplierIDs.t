#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift(@INC, './modules') }
BEGIN {
    use Test::Most;
    use_ok('UpdatePipeline::VRTrack::Sample');
    use VRTrack::VRTrack;
    use UpdatePipeline::VRTrack::Project;
    use VRTrack::Individual;
    use VRTrack::Species;
    use NCBI::TaxonLookup;
}

# test setup
my $vrtrack = VRTrack::VRTrack->new({database => "vrtrack_test",host => "localhost",port => 3306,user => "root",password => undef});
delete_test_data($vrtrack);
my $vproject = UpdatePipeline::VRTrack::Project->new(name => 'My project', external_id => 1234, _vrtrack => $vrtrack)->vr_project();
$vproject->update;

# # create sample with no taxon_id, and common_name_required => 0. Species should be added.
ok my $sample1 = UpdatePipeline::VRTrack::Sample->new(common_name_required => 0, name => 'Some name', common_name => 'SomeHuman', _vrtrack => $vrtrack,_vr_project => $vproject),' initialise sample with no taxon_id';
ok my $vr_sample1 = $sample1->vr_sample(), 'create a vr sample';
isa_ok $vr_sample1->individual->species, "VRTrack::Species";
is $vr_sample1->individual->species->name, "SomeHuman", 'get the species back';
 
# create sample with taxon_id. Species should be created with taxon_id and name
ok my $sample2 = UpdatePipeline::VRTrack::Sample->new(common_name_required => 0, name => 'Some other name', common_name => 'Homo sapiens', taxon_id => 9606, _vrtrack => $vrtrack, _vr_project => $vproject),' initialise sample with taxon_id';
ok my $vr_sample2 = $sample2->vr_sample(), 'create a vr sample';
isa_ok $vr_sample2->individual->species, "VRTrack::Species";
is $vr_sample2->individual->species->name, "Homo sapiens", 'get correct species from taxon_id';
is $vr_sample2->individual->species->taxon_id, "9606", 'get taxon_id from species object';

#create sample with taxon_id and provide supplier_name (but not use_supplier_name - default is 0)
ok my $sample3 = UpdatePipeline::VRTrack::Sample->new(name => 'Yet another name', common_name => 'Homo sapiens', supplier_name => 'HUMAN1', taxon_id => 9606, _vrtrack => $vrtrack, _vr_project => $vproject),' initialise sample with supplier name, but use_supplier_name not set';
ok my $vr_sample3 = $sample3->vr_sample(), 'create a vr sample';
isa_ok $vr_sample3->individual, "VRTrack::Individual";
is $vr_sample3->individual->name, "Yet another name", 'individual name is the sample name';
isnt $vr_sample3->individual->name, "HUMAN1", 'confirm individual name not supplier name provided';

#create sample with taxon_id and provide supplier_name and set use_supplier_name to 1
ok my $sample4 = UpdatePipeline::VRTrack::Sample->new(name => 'Cant think of a name', common_name => 'Homo sapiens', supplier_name => 'HUMAN2', use_supplier_name => 1, taxon_id => 9606, _vrtrack => $vrtrack, _vr_project => $vproject),' initialise sample with supplier_name and use_supplier_name set to 1';
ok my $vr_sample4 = $sample4->vr_sample(), 'create a vr sample';
isa_ok $vr_sample4->individual, "VRTrack::Individual";
is $vr_sample4->individual->name, "HUMAN2", 'individual name is the supplier name name';
isnt $vr_sample4->individual->name, "Cant think of a name", 'confirm individual name is not the sample name';


done_testing();
delete_test_data($vrtrack);

sub delete_test_data
{
  my $vrtrack = shift;
  $vrtrack->{_dbh}->do('delete from project where name="My project"');
  $vrtrack->{_dbh}->do('delete from sample where name like "%name" ');
  $vrtrack->{_dbh}->do('delete from population where name = "Population"');
  $vrtrack->{_dbh}->do('delete from individual where name like "%name"');
  $vrtrack->{_dbh}->do('delete from individual where name = "HUMAN2"');
  $vrtrack->{_dbh}->do('delete from species where name in ("Homo sapiens", "SomeHuman")');
}