package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SangerContactMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'sanger_contact'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'sanger contact not supplied' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

override 'autofix' => sub {
    my ($self, $cell_data) = @_;    
    return ''; # Sanger contact is required but can be set to empty string
};


__PACKAGE__->meta->make_immutable;
no Moose;
1;