package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common;

use Moose;

has 'cell'       => ( is => 'ro', isa => 'Maybe[Str]', default    => undef );
has 'cell_data'  => ( is => 'ro', isa => 'Maybe[Str]', required   =>     1 );
has 'error_list' => ( is => 'ro', isa => 'ArrayRef',   lazy_build =>     1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;