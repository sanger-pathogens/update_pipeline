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