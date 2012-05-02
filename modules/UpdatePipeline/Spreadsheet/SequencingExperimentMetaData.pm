=head1 NAME

SequencingExperimentMetaData.pm  - A class to represent the metadata associated with a single sequencing experiment

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::Validate::SequencingExperimentMetaData;

UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new(

);

=cut

package UpdatePipeline::Spreadsheet::SequencingExperimentMetaData;
use Moose;
use Moose::Util::TypeConstraints;


has 'filename'                   => ( is => 'ro', isa => 'Str', required   => 1 );
has 'mate_filename'              => ( is => 'ro', isa => 'Maybe[Str]');
has 'sample_name'                => ( is => 'ro', isa => 'Str', required   => 1 );
has 'sample_accession_number'    => ( is => 'ro', isa => 'Maybe[Str]');
has 'taxon_id'                   => ( is => 'ro', isa => 'Int', required   => 1 );
has 'library_name'               => ( is => 'ro', isa => 'Str', required   => 1 );
has 'insert_size'                => ( is => 'ro', isa => 'Maybe[Int]');
has 'raw_read_count'             => ( is => 'ro', isa => 'Maybe[Int]');
has 'raw_base_count'             => ( is => 'ro', isa => 'Maybe[Int]');
has 'comments'                   => ( is => 'ro', isa => 'Maybe[Str]');

1;

