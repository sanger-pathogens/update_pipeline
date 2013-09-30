package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SizeNotNumber;

use Moose;
use Scalar::Util qw(looks_like_number);
extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error';

has 'cell'        => ( is => 'ro', isa => 'Maybe[Str]', default => 'total_size_of_files_in_gbytes' );
has 'description' => ( is => 'ro', isa => 'Str',        default => 'file size not a number' );
has 'fatal'       => ( is => 'rw', isa => 'Bool',       default => 0 );

override 'autofix' => sub {
    my ($self, $cell_data) = @_;
    
    # remove 'Gb'
    $cell_data =~ s/gb//i;
    
    # remove lead trail space
    $cell_data =~ s/^\s+|\s+$//;
        
    # unset if not number
    $cell_data = undef unless looks_like_number $cell_data;    
    
    return $cell_data;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;