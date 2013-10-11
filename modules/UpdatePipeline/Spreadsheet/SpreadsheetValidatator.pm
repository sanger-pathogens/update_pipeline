package UpdatePipeline::Spreadsheet::SpreadsheetValidatator;
use Moose;
use Moose::Util::TypeConstraints;

use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header;
use UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment;
use UpdatePipeline::Spreadsheet::Validate::Header;
use UpdatePipeline::Spreadsheet::Validate::SequencingExperiments;

has 'filename'              => ( is => 'ro', isa => 'FileName', required   => 1 );
has 'valid_header_metadata' => ( is => 'ro', isa => 'HashRef',  lazy_build => 1 );
has 'valid_rows_metadata'   => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
has '_header_metadata'      => ( is => 'ro', isa => 'HashRef',  lazy_build => 1 );
has '_rows_metadata'        => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );
has '_parser'               => ( is => 'ro', isa => 'UpdatePipeline::Spreadsheet::Parser', lazy_build => 1 );

sub _build_valid_header_metadata
{
    my ($self) = @_;
    my $header_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Header->new(header => $self->_header_metadata);
    return $header_validator->valid_header();
}

sub _build_valid_rows_metadata
{
    my ($self) = @_;
    my @valid_rows_metadata;
    for my $expt (@{$self->_rows_metadata})
    {
        my $row_validator = UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment->new( experiment_row => $expt );
        push @valid_rows_metadata, $row_validator->valid_experiment_row();
    }
    return \@valid_rows_metadata;
}

sub _build__header_metadata
{
    my ($self) = @_;
    return $self->_parser->header_metadata;
}

sub _build__rows_metadata
{
    my ($self) = @_;
    return $self->_parser->rows_metadata;
}

sub _build__parser
{
    my ($self) = @_;
    return UpdatePipeline::Spreadsheet::Parser->new(filename => $self->filename);
}

# basic function confirms valid
sub validate
{
    my ($self) = @_;
    my $valid_head = UpdatePipeline::Spreadsheet::Validate::Header->new(input_header => $self->valid_header_metadata);
    my $valid_expt = UpdatePipeline::Spreadsheet::Validate::SequencingExperiments->new(raw_rows => $self->valid_rows_metadata);

    return($valid_head->is_valid() && $valid_expt->is_valid());
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
