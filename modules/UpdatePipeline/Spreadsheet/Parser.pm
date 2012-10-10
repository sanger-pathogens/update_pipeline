=head1 NAME

Parser.pm   - Take in a spreadsheet with sequencing manifest information and map it to a hash for the header information and an array of hashes for the row data

=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet::Parser;
my $parser = UpdatePipeline::Spreadsheet::Parser->new(
  filename => 't/data/external_data_example.xls'
);
$parser->header_metadata;
$parser->rows_metadata;

=cut

package UpdatePipeline::Spreadsheet::Parser;
use Moose;
use Moose::Util::TypeConstraints;
use Spreadsheet::ParseExcel;
use UpdatePipeline::Exceptions;

subtype 'FileName'
     => as 'Str'
     => where { (-e $_) }
     => message { "$_ file does not exist" };

has 'filename'          => ( is => 'ro', isa => 'FileName', required => 1 );
                                                                                 
has '_worksheet_parser' => ( is => 'ro', isa => 'Spreadsheet::ParseExcel::Worksheet', lazy_build => 1 );
has 'header_metadata'   => ( is => 'ro', isa => 'HashRef',                            lazy_build => 1 );
has 'rows_metadata'     => ( is => 'ro', isa => 'ArrayRef',                           lazy_build => 1 );


sub _build_header_metadata
{
  my ($self) = @_;
  
  my %raw_header = (
    supplier_name                  => $self->_worksheet_parser->get_cell( 0, 1 ) ? $self->_worksheet_parser->get_cell( 0, 1 )->value() : undef,
    supplier_organisation          => $self->_worksheet_parser->get_cell( 1, 1 ) ? $self->_worksheet_parser->get_cell( 1, 1 )->value() : undef,
    internal_contact               => $self->_worksheet_parser->get_cell( 2, 1 ) ? $self->_worksheet_parser->get_cell( 2, 1 )->value() : undef,
    sequencing_technology          => $self->_worksheet_parser->get_cell( 3, 1 ) ? $self->_worksheet_parser->get_cell( 3, 1 )->value() : undef,
    study_name                     => $self->_worksheet_parser->get_cell( 4, 1 ) ? $self->_worksheet_parser->get_cell( 4, 1 )->value() : undef,
    study_accession_number         => $self->_worksheet_parser->get_cell( 5, 1 ) ? $self->_worksheet_parser->get_cell( 5, 1 )->value() : undef,
    total_size_of_files_in_gbytes  => $self->_worksheet_parser->get_cell( 6, 1 ) ? $self->_worksheet_parser->get_cell( 6, 1 )->value() : undef,
    data_to_be_kept_until          => $self->_worksheet_parser->get_cell( 7, 1 ) ? $self->_worksheet_parser->get_cell( 7, 1 )->value() : undef,
  );

  return \%raw_header;
}

sub _build__worksheet_parser
{
  my ($self) = @_;
  my $parser   = Spreadsheet::ParseExcel->new();
  my $workbook = $parser->parse($self->filename);
  
  if ( !defined $workbook ) {UpdatePipeline::Exceptions::InvalidSpreadsheet->throw( error =>  $parser->error() );}
  
  return $workbook->worksheet(0);
}


sub _build_rows_metadata
{
  my ($self) = @_;
  my @raw_rows;
  my $body_offset = 10;
  
  my ( $row_min, $row_max ) = $self->_worksheet_parser->row_range();
  
  for my $row ( $body_offset .. $row_max ) 
  {
     my %current_row = (
        filename                => $self->_worksheet_parser->get_cell($row, 0) ? $self->_worksheet_parser->get_cell($row, 0)->value() : undef,
        mate_filename           => $self->_worksheet_parser->get_cell($row, 1) ? $self->_worksheet_parser->get_cell($row, 1)->value() : undef,
        sample_name             => $self->_worksheet_parser->get_cell($row, 2) ? $self->_worksheet_parser->get_cell($row, 2)->value() : undef,
        sample_accession_number => $self->_worksheet_parser->get_cell($row, 3) ? $self->_worksheet_parser->get_cell($row, 3)->value() : undef,
        taxon_id                => $self->_worksheet_parser->get_cell($row, 4) ? $self->_worksheet_parser->get_cell($row, 4)->value() : undef,
        library_name            => $self->_worksheet_parser->get_cell($row, 5) ? $self->_worksheet_parser->get_cell($row, 5)->value() : undef,
        fragment_size             => $self->_worksheet_parser->get_cell($row, 6) ? $self->_worksheet_parser->get_cell($row, 6)->value() : undef,
        raw_read_count          => $self->_worksheet_parser->get_cell($row, 7) ? $self->_worksheet_parser->get_cell($row, 7)->value() : undef,
        raw_base_count          => $self->_worksheet_parser->get_cell($row, 8) ? $self->_worksheet_parser->get_cell($row, 8)->value() : undef,
        comments                => $self->_worksheet_parser->get_cell($row, 9) ? $self->_worksheet_parser->get_cell($row, 9)->value() : undef,
      );
    $self->_convert_hash_values_empty_strings_to_undef(\%current_row);
    if(! defined($current_row{filename}))
    {
      next;
    }
    push(@raw_rows, \%current_row);
    
  }
  return \@raw_rows;
}

sub _convert_hash_values_empty_strings_to_undef
{
   my ($self,$input_hash) = @_;
   for my $key (keys %{$input_hash})
   {
     if(defined($input_hash->{$key}) && $input_hash->{$key} eq '')
     {
       $input_hash->{$key} = undef;
     }
   }
   return $input_hash;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
