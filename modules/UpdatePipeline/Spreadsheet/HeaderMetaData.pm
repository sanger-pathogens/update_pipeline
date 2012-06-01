=head1 NAME

HeaderMetaData.pm  - A class to represent the header metadata

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::Validate::HeaderMetaData;

UpdatePipeline::Spreadsheet::HeaderMetaData->new(
  supplier_name                  => 'John Doe',
  supplier_organisation          => 'Somewhere',
  internal_contact               => 'Jane Doe',
  sequencing_technology          => undef,
  study_name                     => 'My Study Name',
  study_accession_number         => 'ERS123',
  total_size_of_files_in_gbytes  => '2.2',
  data_to_be_kept_until          => '23/1/2013'
);

=cut

package UpdatePipeline::Spreadsheet::HeaderMetaData;
use Moose;
use Moose::Util::TypeConstraints;

has 'supplier_name'                 => ( is => 'ro', isa => 'Str', required   => 1 );
has 'supplier_organisation'         => ( is => 'ro', isa => 'Str', required   => 1 );
has 'internal_contact'              => ( is => 'ro', isa => 'Str', required   => 1 );
has 'sequencing_technology'         => ( is => 'ro', isa => 'Str', default    => 'SLX' );
has 'study_name'                    => ( is => 'ro', isa => 'Str', required   => 1 );
has 'study_accession_number'        => ( is => 'ro', isa => 'Maybe[Str]');
has 'total_size_of_files_in_gbytes' => ( is => 'ro', isa => 'Maybe[Str]');
has 'data_to_be_kept_until'         => ( is => 'ro', isa => 'Maybe[Str]');

__PACKAGE__->meta->make_immutable;

no Moose;

1;
