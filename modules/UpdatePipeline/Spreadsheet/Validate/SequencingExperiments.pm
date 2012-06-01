=head1 NAME

SequencingExperiments.pm  - Validate the metadata assosiated with a sequencing experiment, basically a row in the main body of the spreadsheet

=head1 SYNOPSIS

# in a Moose class
use UpdatePipeline::Spreadsheet::Validate::SequencingExperiments;

subtype 'SequencingExperiments'
     => as 'ArrayRef'
     => where { UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new( raw_rows => $_ )->is_valid() }
     => message { "$_ is not a valid SequencingExperiments" };

has 'raw_rows'   => ( is => 'ro', isa => 'SequencingExperiments', required   => 1 );

=cut

package UpdatePipeline::Spreadsheet::Validate::SequencingExperiments;
use Moose;
use Try::Tiny;
use UpdatePipeline::Spreadsheet::SequencingExperimentMetaData;

has 'raw_rows' => ( is => 'ro', isa => 'ArrayRef', required   => 1 );

sub is_valid
{
  my ($self) = @_;
  
  return try{
    for my $raw_row (@{$self->raw_rows})
    {
       UpdatePipeline::Spreadsheet::SequencingExperimentMetaData->new($raw_row);
    }
    1;
  }
  catch{
    0;
  };
  
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
