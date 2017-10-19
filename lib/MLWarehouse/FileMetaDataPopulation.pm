package MLWarehouse::FileMetaDataPopulation;

# ABSTRACT: Take in a FileMetaData object and try and fill in the blanks with data from the ML Warehouse

=head1 SYNOPSIS

use MLWarehouse::FileMetaDataPopulation;
my $file = MLWarehouse::FileMetaDataPopulation->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut
use Moose;
use MLWarehouse::Study;
use MLWarehouse::IseqProductMetrics;
use MLWarehouse::IseqRunLaneMetrics;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::CommonFileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

sub populate
{
  my($self) = @_;
  MLWarehouse::Study->new(  file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  MLWarehouse::IseqProductMetrics->new(file_meta_data => $self->file_meta_data, _dbh => $self->_dbh)->populate();
  MLWarehouse::IseqRunLaneMetrics->new(file_meta_data => $self->file_meta_data, _dbh => $self->_dbh)->populate();
}


sub post_populate
{
  my($self) = @_;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
