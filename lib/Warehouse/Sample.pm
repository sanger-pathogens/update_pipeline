package Warehouse::Sample;
# ABSTRACT: Take in a sample name or ssid and fill in the missing data in the file metadata object
=head1 SYNOPSIS

use Warehouse::Sample;
my $file = Warehouse::Sample->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut
use Moose;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );
our $all_warehouse_sample_details;
our $name_to_ssid;
has '_warehouse_sample_details' => ( is => 'ro', lazy_build => 1, isa => 'HashRef' );

sub _build__warehouse_sample_details {
    my $self = shift;
    
    unless (defined $all_warehouse_sample_details) {
        my $dbh = $self->_dbh;
        
        # we just get the whole table because current_samples has no key to study
        # table, and the study_samples table has no indexes on study_internal_id
        my $sql = qq[select internal_id, name, supplier_name, common_name, public_name from current_samples;];
        
        # the result is stored in a class variable, so we only do this once
        $all_warehouse_sample_details = $dbh->selectall_hashref($sql, 'internal_id');
        
        while (my ($ssid, $details) = each %{$all_warehouse_sample_details}) {
            $name_to_ssid->{$details->{name}} = $ssid;
        }
    }
    
    return $all_warehouse_sample_details;
}

sub populate
{
  my($self) = @_;
  $self->_populate_ssid_from_name;
  $self->_populate_name_from_ssid;
  
  # since there is no cost, we do this straight away, which also lets us test
  # for changes in supplier and public names
  $self->_populate_supplier_and_public_name;
  1;
}

sub post_populate
{
  # (we used to populate supplier name, but now do it in populate())
  1;
}

sub _populate_ssid_from_name
{
  my($self) = @_;
  return unless defined($self->file_meta_data->sample_name) ;
  if( !defined($self->file_meta_data->sample_ssid)  || !defined($self->file_meta_data->sample_common_name)   )
  {
    my $sample_name = $self->file_meta_data->sample_name;
    $self->_warehouse_sample_details; # build the name_to_ssid lookup if not already built
    my $ssid = $name_to_ssid->{$sample_name} || return;
    my $warehouse_sample_details = $self->_warehouse_sample_details->{$ssid};
    
    $self->file_meta_data->sample_ssid($ssid) if(! defined($self->file_meta_data->sample_ssid));
    $self->file_meta_data->sample_common_name($warehouse_sample_details->{common_name}) if(! defined($self->file_meta_data->sample_common_name));
  }
}

sub _populate_name_from_ssid
{
  my($self) = @_;
  return unless defined($self->file_meta_data->sample_ssid) ;
  if( !defined($self->file_meta_data->sample_name)  || !defined($self->file_meta_data->sample_common_name)   )
  {
    my $warehouse_sample_details = $self->_warehouse_sample_details->{$self->file_meta_data->sample_ssid} || return;
    $self->file_meta_data->sample_name($warehouse_sample_details->{name}) if(! defined($self->file_meta_data->sample_name));
    $self->file_meta_data->sample_common_name($warehouse_sample_details->{common_name}) if(! defined($self->file_meta_data->sample_common_name));
  }
}

sub _populate_supplier_and_public_name
{
  my($self) = @_;
  
  return unless defined($self->file_meta_data->sample_ssid);
  my $warehouse_sample_details = $self->_warehouse_sample_details->{$self->file_meta_data->sample_ssid} || return;
  
  $self->file_meta_data->supplier_name($warehouse_sample_details->{supplier_name}) if defined $warehouse_sample_details->{supplier_name};
  $self->file_meta_data->public_name($warehouse_sample_details->{public_name}) if defined $warehouse_sample_details->{public_name};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
