=head1 NAME

NPGInformation.pm   - Take in a lane name and try to extract information from the npg_information table

=head1 SYNOPSIS

use Warehouse::NPGInformation;
my $file = Warehouse::NPGInformation->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut

package Warehouse::NPGInformation;
use Moose;
use Sfind::Sfind;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

has '_id_run'          => ( is => 'rw', isa => 'Int');
has '_position'        => ( is => 'rw', isa => 'Int');


sub populate
{
  my($self) = @_;
  return if($self->file_meta_data->file_name_without_extension =~ /#/);
  
  unless ((!defined($self->file_meta_data->study_ssid))   ||
  (!defined($self->file_meta_data->sample_ssid))  ||
  (!defined($self->file_meta_data->library_ssid)) ||
  (!defined($self->file_meta_data->library_name)))
  {
   return; 
  }

  $self->_split_file_name;
  $self->_populate_from_npg_information_table;
}

sub _populate_from_npg_information_table
{
  my($self) = @_;
  if(defined($self->_id_run) && defined($self->_position)  )
  {
    my $id_run = $self->_id_run;
    my $position = $self->_position;
    my $sql = qq[select study_id, sample_id, asset_id, asset_name from npg_information where id_run = "$id_run" AND position = $position limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @study_warehouse_details  = $sth->fetchrow_array;
    if(@study_warehouse_details > 0)
    {
      $self->file_meta_data->study_ssid($study_warehouse_details[0])   if(!defined($self->file_meta_data->study_ssid));
      $self->file_meta_data->sample_ssid($study_warehouse_details[1])  if(!defined($self->file_meta_data->sample_ssid));
      $self->file_meta_data->library_ssid($study_warehouse_details[2]) if(!defined($self->file_meta_data->library_ssid));
      $self->file_meta_data->library_name($study_warehouse_details[3]) if(!defined($self->file_meta_data->library_name));
    }
  }
}

sub _split_file_name
{
  my($self) = @_;
  if($self->file_meta_data->file_name_without_extension =~ /^([\d]+)_([\d]+)$/)
  {
    $self->_id_run($1);
    $self->_position($2);
  }
}


1;