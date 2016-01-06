package GCLPWarehouse::Study;

# ABSTRACT: Take in a study ssid and fill in the missing data in the file metadata object

=head1 SYNOPSIS

use GCLPWarehouse::Study;
my $file = GCLPWarehouse::Study->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut
use Moose;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

sub populate
{
  my($self) = @_;
  $self->_populate_data_access_group_from_ssid;

  1;
}

sub _populate_data_access_group_from_ssid
{
  my($self) = @_;
  if(defined($self->file_meta_data->study_ssid) && ! defined($self->file_meta_data->data_access_group)  )
  {
    my $study_ssid = $self->file_meta_data->study_ssid;
    my $sql = qq[select data_access_group from study where id_lims = "SQSCP" AND id_study_lims = "$study_ssid" limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @study_warehouse_details  = $sth->fetchrow_array;
    if(@study_warehouse_details > 0)
    {
      $self->file_meta_data->data_access_group($study_warehouse_details[0]);
    }
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
