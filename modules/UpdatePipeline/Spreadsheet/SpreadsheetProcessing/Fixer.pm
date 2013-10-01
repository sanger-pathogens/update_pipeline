package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Fixer;

use Moose;

has 'header_metadata'  => ( is => 'rw', isa => 'HashRef',  required => 1 );
has 'rows_metadata'    => ( is => 'rw', isa => 'ArrayRef', required => 1 );
has 'header_error'     => ( is => 'rw', isa => 'ArrayRef', required => 1 );
has 'experiment_error' => ( is => 'rw', isa => 'ArrayRef', required => 1 );

# Move to own modules
sub _is_error
{
    my ($self, $err) = @_;
    my $class = blessed $err;
    return $class =~ m/UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error/;
}

sub _is_warning
{
    my ($self, $err) = @_;
    my $class = blessed $err;
    return $class =~ m/UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Warning/;
}

sub _is_fatal_error
{
    my ($self, $err) = @_;
    return undef if $self->_is_warning($err);
    return $err->fatal();
}

sub _is_fixable_error
{
    my ($self, $err) = @_;
    return undef if $self->_is_warning($err);
    return $err->fatal() ? 0:1;
}

sub _fix_head
{
    my ($self) = @_;
    
    for my $err (@{ $self->header_error })
    {
        if( $self->_is_fixable_error($err) )
        {
            my $cell = $err->cell;
            my $cell_data = $self->header_metadata->{$cell};
            my $updated_cell_data = $err->autofix($cell_data);
            $self->header_metadata->{$cell} = $updated_cell_data unless $err->fatal(); # update metadata if fix is OK.
        }
    }
}

sub _fix_expt
{
    my ($self) = @_;
    
    for my $err (@{ $self->experiment_error })
    {
        if( $self->_is_fixable_error($err) )
        {
            my $row  = $err->row - 1; 
            my $cell = $err->cell; 
            my $cell_data = $self->rows_metadata->[$row]->{$cell};
            my $updated_cell_data = $err->autofix($cell_data);
            $self->rows_metadata->[$row]->{$cell} = $updated_cell_data unless $err->fatal(); # update metadata if fix is OK.
        }
    }

}

sub fix_errors
{
    my ($self) = @_;
    
    $self->_fix_head();
    $self->_fix_expt();
    
    return;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;