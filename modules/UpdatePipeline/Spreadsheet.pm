# override sub _build__files_metadata to read in from file
# create a parsed object for the spreadsheet
# fill in sensible default values
# validate everything else
# Disable warehouse population


# when importing the files
# if an md5.sum file is provided in a directory, the md5's are checked.
# the filename can contain a relative path
# need to use dropdowns in the spreadsheet
# its paired if it has a mate file

# one file per study, per sequencing technology

# incrementally update the ssid of the study/sample/library/...

# essential information:
# filename & mate
# taxon
# platform

=head1 NAME

Spreadsheet.pm   - Main driver class which pulls everything together to allow for a spreadsheet to be parsed, validated, converted to filemetadata objects and loaded into the pipeline


=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet;
my $spreadsheet = UpdatePipeline::Spreadsheet->new(
  filename => 't/data/external_data_example.xls'
);
$spreadsheet->files_metadata;

=cut

package UpdatePipeline::Spreadsheet;
use Moose;
use Try::Tiny;
use UpdatePipeline::Exceptions;
use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetMetaData;


has 'filename'         => ( is => 'ro', isa => 'Str',      required => 1 );
has 'files_metadata'   => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

sub _build_files_metadata
{
  my ($self) = @_;
  my $parser;
  my $spreadsheet_metadata;
  
  try{
    $parser = UpdatePipeline::Spreadsheet::Parser->new(filename => $self->filename);
  }
  catch
  {
    UpdatePipeline::Exceptions::InvalidSpreadsheet->throw( error =>  "Couldnt parse the input spreadsheet");
  };
  
  try{
    $spreadsheet_metadata = UpdatePipeline::Spreadsheet::SpreadsheetMetaData->new(
      input_header => $parser->header_metadata,
      raw_rows     => $parser->rows_metadata
    );
  }
  catch
  {
     UpdatePipeline::Exceptions::InvalidSpreadsheetMetaData->throw( error =>  "The data in the spreadsheet is invalid");
  };
  return $spreadsheet_metadata->files_metadata;
}


1;