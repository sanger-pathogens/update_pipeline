package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::SizeMissing;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'total_size_of_files_in_gbytes' );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'file size not supplied' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;