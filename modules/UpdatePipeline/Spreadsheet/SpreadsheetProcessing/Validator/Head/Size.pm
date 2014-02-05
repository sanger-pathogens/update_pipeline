package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Size;

use Moose;
use Scalar::Util qw(looks_like_number);
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::SizeMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SizeNotNumber;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'total_size_of_files_in_gbytes' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    if( ! defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::SizeMissing->new();
    }
    elsif( ! looks_like_number $self->cell_data )
    {
        # not a number
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SizeNotNumber->new();
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;