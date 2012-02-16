=head1 NAME

FileMetaDataPopulation.pm   - Take in a FileMetaData object and try and fill in the blanks with data from the Warehouse (using SFind where possible)

=head1 SYNOPSIS

use Warehouse::FileMetaDataPopulation;
my $file = Warehouse::FileMetaDataPopulation->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut

package Warehouse::FileMetaDataPopulation;
use Moose;
use Sfind::Sfind;
use Warehouse::Library;
use Warehouse::Study;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

sub populate
{
  my($self) = @_;
  
  Warehouse::Library->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Study->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Sample->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();

  
}


1;