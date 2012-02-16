=head1 NAME

Library.pm   - Take in a library name or ssid and fill in the missing data in the file metadata object

=head1 SYNOPSIS

use Warehouse::Library;
my $file = Warehouse::Library->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut

package Warehouse::Library;
use Moose;
use Sfind::Sfind;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );


sub populate
{
  my($self) = @_;
  $self->_populate_ssid_from_name;
}

sub _populate_ssid_from_name
{
  my($self) = @_;
  if(defined($self->file_meta_data->library_name) && ! defined($self->file_meta_data->library_ssid)  )
  {
    my $library_name = $self->file_meta_data->library_name;
    my $sql = qq[select internal_id as library_ssid from current_libraries where name = "$library_name" limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @library_warehouse_details  = $sth->fetchrow_array;
    if(@library_warehouse_details > 0)
    {
      $self->file_meta_data->library_ssid($library_warehouse_details[0]);
    }
  }
}


1;