package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::ReadCountFormat;

use Moose;
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'raw_read_count'   );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'read count is not an integer' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

override 'autofix' => sub {
    my ($self, $cell_data) = @_;
    
    # remove lead trail space
    $cell_data =~ s/^\s+|\s+$//;
        
    # unset basecount if not integer
    $cell_data = 0 unless $cell_data =~ m/^\d+$/;    
    
    return $cell_data;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;