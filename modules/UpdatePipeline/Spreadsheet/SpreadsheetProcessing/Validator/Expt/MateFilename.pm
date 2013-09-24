package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'filename' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    return [] unless defined $self->cell_data; # allow to be undef

    # Filename format
    my $filename = $self->cell_data;
    if( $filename =~ m/\// )
    {
        # filename contains path
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenamePath->new( row => $self->row );
        # remove path
        my @path = split /\//, $filename;
        $filename = shift @path;                
    }
    
    if( $filename eq '' ) 
    {
        # No filename after path removal
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameMissing->new( row => $self->row );
        return \@error_list;

    }    

    if($filename =~ m/^s+/ || $filename =~ m/\s+$/)
    {
        # leading/trailing space
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameLeadTrailSpace->new( row => $self->row );
        $filename =~ s/^\s+|\s+$//g; # remove so not counted twice
    }

    if($filename =~ m/[^\w\#\.]/)
    {
        # invalid character
        push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::MateFilenameFormat->new( row => $self->row );
    }
    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;