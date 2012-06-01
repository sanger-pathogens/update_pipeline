=head1 NAME

Study.pm   - Take in a study name or ssid and fill in the missing data in the file metadata object

=head1 SYNOPSIS

use Warehouse::Study;
my $file = Warehouse::Study->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut

package Warehouse::Study;
use Moose;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );


sub populate
{
  my($self) = @_;
  $self->_populate_ssid_from_name;
  $self->_populate_name_from_ssid;
  1;
}

sub _populate_ssid_from_name
{
  my($self) = @_;
  if(defined($self->file_meta_data->study_name) && ! defined($self->file_meta_data->study_ssid)  )
  {
    my $study_name = $self->file_meta_data->study_name;
    my $sql = qq[select internal_id as study_ssid from current_studies where name = "$study_name" limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @study_warehouse_details  = $sth->fetchrow_array;
    if(@study_warehouse_details > 0)
    {
      $self->file_meta_data->study_ssid($study_warehouse_details[0]);
    }
  }
}

sub _populate_name_from_ssid
{
  my($self) = @_;
  if(! defined($self->file_meta_data->study_name) && defined($self->file_meta_data->study_ssid)  )
  {
    my $study_ssid = $self->file_meta_data->study_ssid;
    my $sql = qq[select name  from current_studies where internal_id = "$study_ssid" limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @study_warehouse_details  = $sth->fetchrow_array;
    if(@study_warehouse_details > 0)
    {
      $self->file_meta_data->study_name($study_warehouse_details[0]);
    }
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
