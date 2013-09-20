package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt;
use Scalar::Util qw(blessed);


has 'header_metadata' => ( is => 'ro', isa => 'HashRef',  required   => 1 );
has 'rows_metadata'   => ( is => 'ro', isa => 'ArrayRef', required   => 1 );
has 'header_error'    => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
has 'rows_error'      => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

sub _build_header_error
{
    my ($self) = @_;
    my $head_validator = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Head->new( header_metadata => $self->header_metadata );
    return $head_validator->error_list;
}

sub _build_rows_error
{
    my ($self) = @_;
    my $expt_validator = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt->new( rows_metadata => $self->rows_metadata );
    return $expt_validator->error_list;
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

sub _get_warning_list
{
    my ($self, $error_list) = @_;
    my @warnings = ();
    for my $err (@$error_list)
    {
        push @warnings, $err if $self->_is_warning($err);
    }
    return \@warnings;
}

sub _get_error_list
{
    my ($self, $error_list) = @_;
    my @errors = ();
    for my $err (@$error_list)
    {
        push @errors, $err if $self->_is_error($err);
    }
    return \@errors;
}

sub header_warning_list
{
    my ($self) = @_;
    return $self->_get_warning_list( $self->header_error );
}

sub header_error_list
{
    my ($self) = @_;
    return $self->_get_error_list( $self->header_error );
}

sub rows_warning_list
{
    my ($self) = @_;
    return $self->_get_warning_list( $self->rows_error );
}

sub rows_error_list
{
    my ($self) = @_;
    return $self->_get_error_list( $self->rows_error );
}

sub total_errors_found
{
    my ($self) = @_;
    my $total_error = 0;
    $total_error += scalar @{$self->header_error_list};
    $total_error += scalar @{$self->rows_error_list};
    return $total_error;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;