package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Reporter;

use Moose;
use Text::CSV;

has 'header_error'     => ( is => 'ro', isa => 'ArrayRef',   required   => 1 ); # header errors
has 'experiment_error' => ( is => 'ro', isa => 'ArrayRef',   required   => 1 ); # experiment errors
has 'filehandle'       => ( is => 'ro', isa => 'FileHandle', required   => 1 ); # output filehandle
has '_csv_out'         => ( is => 'ro', isa => 'Text::CSV',  lazy_build => 1 ); # output CSV
has '_column_header'   => ( is => 'ro', isa => 'ArrayRef',   lazy_build => 1 ); # column header

sub _build__csv_out
{
    my ($self) = @_;
    my $csv = Text::CSV->new( { binary => 1 } );
    $csv->eol("\r\n");
    return $csv;
}

sub _build__column_header
{
    my ($self) = @_;
    my @header = ('Type','Location','Cell','Description','Fixable');
    return \@header;
}

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

sub _get_header_error_output_row
{
    my ($self, $err) = @_;
    my ($type,$location,$cell,$description,$fixable);
    
    $type         = $self->_is_error($err) ? 'Error':'Warning';
    $location     = 'Header';
    $cell         = $err->cell;
    $description  = $err->description;
    $fixable      = $self->_is_fixable_error($err) ? 'fixable error':'';

    return [$type,$location,$cell,$description,$fixable];
}

sub _get_expt_error_output_row
{
    my ($self, $err) = @_;
    my ($type,$location,$cell,$description,$fixable);
    
    $type         = $self->_is_error($err) ? 'Error':'Warning';
    $location     = $err->row ? $err->row : 'NA';
    $cell         = defined $err->cell ? $err->cell : 'NA';
    $description  = $err->description;
    $fixable      = $self->_is_fixable_error($err) ? 'fixable error':'';

    return [$type,$location,$cell,$description,$fixable];
}

sub _get_all_header
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->header_error})
    {
        push @csv_row, $self->_get_header_error_output_row($err);
    }    
    return \@csv_row;
}

sub _get_all_experiment
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->experiment_error})
    {
        push @csv_row, $self->_get_expt_error_output_row($err);
    }    
    return \@csv_row;
}

sub _get_header_error
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->header_error})
    {
        push @csv_row, $self->_get_header_error_output_row($err) if $self->_is_error($err);
    }    
    return \@csv_row;
}

sub _get_header_warning
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->header_error})
    {
        push @csv_row, $self->_get_header_error_output_row($err) if $self->_is_warning($err);;
    }    
    return \@csv_row;
}

sub _get_experiment_error
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->experiment_error})
    {
        push @csv_row, $self->_get_expt_error_output_row($err) if $self->_is_error($err);
    }    
    return \@csv_row;
}

sub _get_experiment_warning
{
    my ($self) = @_;
    my @csv_row = ();
    for my $err (@{$self->experiment_error})
    {
        push @csv_row, $self->_get_expt_error_output_row($err) if $self->_is_warning($err);
    }    
    return \@csv_row;
}

sub _get_summary
{
    my ($self) = @_;
    my @summary;
    push @summary, ['header errors',scalar @{$self->_get_header_error}];
    push @summary, ['header warnings',scalar @{$self->_get_header_warning}];
    push @summary, ['experiment errors',scalar @{$self->_get_experiment_error}]; 
    push @summary, ['experiment warnings',scalar @{$self->_get_experiment_warning}]; 
    return \@summary;
}

sub full_report
{
    my ($self) = @_;
    
    my @output_rows;
    # Title 
    push @output_rows, $self->_column_header;
    # Header Errors and Warnings
    push @output_rows, @{$self->_get_all_header};
    # Experiment Errors and Warnings
    push @output_rows, @{$self->_get_all_experiment};
    # Summary
    push @output_rows, @{$self->_get_summary};

    # Output CSV
    for my $row (@output_rows)
    {
        $self->_csv_out->print($self->filehandle,$row)
    }

    return 1;
}

sub summary_report
{
    my ($self) = @_;
    # Summary
    for my $row (@{$self->_get_summary})
    {
        $self->_csv_out->print($self->filehandle,$row)
    }
    return 1;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;