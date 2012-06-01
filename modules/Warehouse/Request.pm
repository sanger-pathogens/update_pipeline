=head1 NAME

Request.pm   - Take in a sample name or ssid and fill in the missing data in the file metadata object

=head1 SYNOPSIS

use Warehouse::Request;
my $file = Warehouse::Request->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->post_populate();

=cut

package Warehouse::Request;
use Moose;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

sub post_populate
{
  my($self) = @_;
  return 0 unless(defined($self->file_meta_data->library_ssid));
  $self->_populate_fragment_size_from_library_ssid;
  1;
}

sub _populate_fragment_size_from_library_ssid
{
  my($self) = @_;
  
  if(! defined($self->file_meta_data->fragment_size_from) || ! defined($self->file_meta_data->fragment_size_to) )
  {
    my $library_ssid = $self->file_meta_data->library_ssid;
    my $sql = qq[select fragment_size_from, fragment_size_to from current_requests where target_asset_internal_id = $library_ssid AND fragment_size_from is not NULL AND fragment_size_to is not NULL limit 1];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @sample_warehouse_details  = $sth->fetchrow_array;
    if(@sample_warehouse_details > 0)
    {
      $self->file_meta_data->fragment_size_from($sample_warehouse_details[0]);
      $self->file_meta_data->fragment_size_to($sample_warehouse_details[1]);
    }
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
