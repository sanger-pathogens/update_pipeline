package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common;

use Moose;

has 'row'        => ( is => 'ro', isa => 'Maybe[Int]', required   =>     1 );
has 'cell'       => ( is => 'ro', isa => 'Maybe[Str]', default    => undef );
has 'cell_data'  => ( is => 'ro', isa => 'Maybe[Str]', required   =>     1 );
has 'error_list' => ( is => 'ro', isa => 'ArrayRef',   lazy_build =>     1 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;