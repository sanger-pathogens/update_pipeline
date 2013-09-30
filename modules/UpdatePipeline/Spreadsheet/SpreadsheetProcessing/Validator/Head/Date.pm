package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Date;

use Moose;
use Scalar::Util qw(looks_like_number);
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::DateMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::DateFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'data_to_be_kept_until' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    if( ! defined $self->cell_data)
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning::DateMissing->new();
    }
    elsif( $self->cell_data !~ m/^\d{2}\D\d{2}\D\d{4}$/ && $self->cell_data !~ m/^\d{4}\D\d{2}\D\d{2}$/ )
    {
        # expected format from excel is either dd.mm.yyyy or yyyy-mm-dd
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::DateFormat->new();
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;