package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Base;

# Error base class

use Moose;

has 'row'         => ( is => 'ro', isa => 'Maybe[Int]', default => undef   );
has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => undef   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'error' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;