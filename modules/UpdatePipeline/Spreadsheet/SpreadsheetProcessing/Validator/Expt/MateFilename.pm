package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::MateFilename;

use Moose;

extends 'UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Common';

has 'cell' => ( is => 'ro', isa => 'Str', default => 'filename' );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    return [] unless defined $self->cell_data; # allow to be undef

    # add checks here

    
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;