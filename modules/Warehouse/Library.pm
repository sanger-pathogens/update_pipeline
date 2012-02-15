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
  #$self->_populate_library_data_from_ssid;
}

sub _populate_ssid_from_name
{
  my($self) = @_;
  if(defined($self->file_meta_data->library_name) && ! defined($self->file_meta_data->library_ssid)  )
  {
    my $library_name = $self->file_meta_data->library_name;
    my $sql = qq[select internal_id as library_ssid from current_library where name = "$library_name" limit 1;];
    my $sth = $self->_dbh->do($sql);
    my @library_warehouse_details  = $sth->fetchrow_array;
    if(@library_warehouse_details > 0)
    {
      $self->file_meta_data->library_ssid($library_warehouse_details[0]);
    }
  }
}

# This may not be needed at all for the pipelines to run.
#sub _populate_library_data_from_ssid
#{
#  my($self) = @_;
#  if(defined($self->file_meta_data->library_ssid) )
#  {
#    my $warehouse_library = Sfind::Library->new({dbh => $self->_dbh, id => $self->file_meta_data->library_ssid});
#    if(defined($warehouse_library))
#    {
#      $warehouse_library->fragment_size_from();
#      $warehouse_library->fragment_size_to();
#    }
#    
#  }
#  
#}


1;