package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameLeadTrailSpace;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment filename lead/trail space' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

# remove trailing/leading spaces
override 'autofix' => sub {
    my ($self, $cell_data) = @_;
    $cell_data =~ s/^\s+|\s+$//;
    return $cell_data;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;