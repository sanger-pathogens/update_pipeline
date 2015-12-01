package GCLPWarehouse::FileMetaDataPopulation;

# ABSTRACT: Take in a FileMetaData object and try and fill in the blanks with data from the GCLP Warehouse

=head1 SYNOPSIS

use GCLPWarehouse::FileMetaDataPopulation;
my $file = GCLPWarehouse::FileMetaDataPopulation->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut
use Moose;
use GCLPWarehouse::Study;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

sub populate
{
  my($self) = @_;
  GCLPWarehouse::Study->new(  file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
}

sub post_populate
{
  my($self) = @_;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
