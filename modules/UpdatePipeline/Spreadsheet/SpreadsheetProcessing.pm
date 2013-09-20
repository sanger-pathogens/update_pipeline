package UpdatePipeline::Spreadsheet::SpreadsheetProcessing;

use Moose;
use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator;

has 'filename'          => ( is => 'ro', isa => 'FileName', required   => 1 );
has 'header_metadata'   => ( is => 'ro', isa => 'HashRef',  lazy_build => 1 );
has 'rows_metadata'     => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
has '_parser'           => ( is => 'ro', isa => 'UpdatePipeline::Spreadsheet::Parser', lazy_build => 1 );
has '_header_error'     => ( is => 'rw', isa => 'ArrayRef',  default   => sub { [] } ); # header errors
has '_experiment_error' => ( is => 'rw', isa => 'ArrayRef',  default   => sub { [] } ); # experiment errors

sub _build_header_metadata
{
    my ($self) = @_;
    return $self->_parser->header_metadata;
}

sub _build_rows_metadata
{
    my ($self) = @_;
    return $self->_parser->rows_metadata;
}

sub _build__parser
{
    my ($self) = @_;
    return UpdatePipeline::Spreadsheet::Parser->new(filename => $self->filename);
}

sub validate
{
    my ($self) = @_;

    my $validator = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator->new( header_metadata => $self->header_metadata,
                                                                                        rows_metadata   => $self->rows_metadata );
    $self->_header_error($validator->header_error);
    $self->_experiment_error($validator->rows_error);
    
    return $validator->total_errors_found ? 0:1;
}

sub report
{
    # write report to report file or stdout    
}

sub fix
{
    # auto fix errors
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;