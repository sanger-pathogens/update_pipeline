package UpdatePipeline::Spreadsheet::SpreadsheetProcessing;

use Moose;
use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Reporter;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Fixer;

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

sub full_error_list
{
    my ($self) = @_;

    $self->validate(); # update error list
    my @all_error = ();
    push @all_error, @{$self->_header_error };
    push @all_error, @{$self->_experiment_error };

    return \@all_error;
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
    my ($self, $report_filename) = @_;

    # write report to report file or stdout
    my $csv_filehandle;
    if(defined $report_filename)
    {
        open($csv_filehandle, '>', $report_filename) or die "cannot open file $report_filename\n";
    }
    else
    {
        open($csv_filehandle, '>&', \*STDOUT ) or die "cannot open filehandle to STDOUT\n";
    }

    my $reporter = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Reporter->new( filehandle       => $csv_filehandle,
                                                                                      header_error     => $self->_header_error,
                                                                                      experiment_error => $self->_experiment_error );
    $reporter->full_report;

    return 1;
}

sub fix
{
    my ($self) = @_;

    # auto fix errors
    my $fixer = UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Fixer->new( header_metadata  => $self->header_metadata,
                                                                                rows_metadata    => $self->rows_metadata,
                                                                                header_error     => $self->_header_error,
                                                                                experiment_error => $self->_experiment_error );
    $fixer->fix_errors();

    # update metadata 
    %{ $self->header_metadata } = %{ $fixer->header_metadata };
    @{ $self->rows_metadata } = @{ $self->rows_metadata };

    return $self->validate;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;