package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenamePath;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'mate_filename'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'experiment mate filename has directory path' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

# remove filename path
override 'autofix' => sub {
    my ($self, $cell_data) = @_;

    my @path = split(/\//,$cell_data,-1);
    my $filename = pop @path;

    return undef if $filename eq '';
    return $filename;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;