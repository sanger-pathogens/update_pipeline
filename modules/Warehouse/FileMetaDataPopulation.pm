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
use Warehouse::Library;
use Warehouse::Study;
use Warehouse::Sample;
use Warehouse::NPGInformation;
use Warehouse::NPGPlexInformation;
use Warehouse::Request;

has 'file_meta_data'   => ( is => 'rw', isa => 'UpdatePipeline::FileMetaData', required => 1 );
has '_dbh'             => ( is => 'rw',                                        required => 1 );

# this is for data that should normally be in IRODs but isnt so it needs to be looked up (MySQL intensive)
sub populate
{
  my($self) = @_;
  # do this check twice because its more likely to be correct than the NPG table.
  Warehouse::Library->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Study->new(  file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Sample->new( file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  
  Warehouse::NPGInformation->new(    file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::NPGPlexInformation->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();

  Warehouse::Library->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Study->new(  file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
  Warehouse::Sample->new( file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->populate();
}

# this is for nonessential data which needs to be populated if its missing. Since its very DB intensive and its non critical information that we just use as a guideline
# we just look it up if the object has been updated (or is new) for some reason to reduce the number of queries
sub post_populate
{
  my($self) = @_;
  # the order here is very important. Its in decending order of accuracy.
  # Get supplier name for sample
  Warehouse::Sample->new( file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->post_populate();
  # Get requested size for a non multiplexed library
  Warehouse::Library->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->post_populate();
  # Get requested size for a multiplexed library
  Warehouse::Request->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->post_populate();
  # get the median insert size (if NPG have aligned it)
  Warehouse::NPGPlexInformation->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->post_populate();
  Warehouse::NPGInformation->new(file_meta_data => $self->file_meta_data,_dbh => $self->_dbh)->post_populate();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
