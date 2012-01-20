=head1 NAME

File.pm   - Represents a single file with some metadata

=head1 SYNOPSIS

use Warehouse::File;
my $file = Warehouse::File->new(
  file_location => '/seq/1234/1234_5.bam'
  );

my %file_metadata = $file->file_metadata();

=cut

package Warehouse::File;
use Moose;
extends 'Warehouse::Common';

has 'input_metadata'   => ( is => 'rw', isa => 'HashRef', required   => 1 );
has '_dbh'             => ( is => 'rw',  required => 1 );
has 'file_attributes' => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

sub _build_file_attributes
{
  my ($self) = @_;
  my %file_attributes;
  
  return \%file_attributes;
}
1;