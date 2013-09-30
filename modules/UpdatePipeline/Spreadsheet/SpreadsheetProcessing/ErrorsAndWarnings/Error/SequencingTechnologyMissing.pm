package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SequencingTechnologyMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'sequencing_technology'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'sequencing technology not supplied' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

override 'autofix' => sub {
    my ($self, $cell_data) = @_;
    return 'Illumina'; # set to Illumina as default
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;