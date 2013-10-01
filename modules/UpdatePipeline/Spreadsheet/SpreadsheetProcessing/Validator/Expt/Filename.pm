package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Filename;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameMissing;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenamePath;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameLeadTrailSpace;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameFormat;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'filename' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    unless( defined $self->cell_data )
    {
        # not defined
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameMissing->new( row => $self->row );
        return \@error_list;
    }

    # Filename format
    my $filename = $self->cell_data;
    if( $filename =~ m/\// )
    {
        # filename contains path
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenamePath->new( row => $self->row );
        # remove path
        my @path = split /\//, $filename;
        $filename = pop @path;                
    }
    
    if( $filename eq '' ) 
    {
        # No filename after path removal
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameMissing->new( row => $self->row );
        return \@error_list;

    }    

    if($filename =~ m/^s+/ || $filename =~ m/\s+$/)
    {
        # leading/trailing space
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameLeadTrailSpace->new( row => $self->row );
        $filename =~ s/^\s+|\s+$//g; # remove so not counted twice
    }

    if($filename =~ m/[^\w\#\.]/)
    {
        # invalid character
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameFormat->new( row => $self->row );
    }

    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;