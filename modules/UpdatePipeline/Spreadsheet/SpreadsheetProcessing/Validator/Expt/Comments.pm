package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Comments;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'comments' );

sub _build_error_list
{
    # always return no errors
    return [];
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;