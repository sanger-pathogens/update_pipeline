# fill in sensible default values
# validate everything else

# when importing the files
# if an md5.sum file is provided in a directory, the md5's are checked.
# the filename can contain a relative path
# need to use dropdowns in the spreadsheet
# its paired if it has a mate file

# one file per study, per sequencing technology

# essential information:
# filename & mate
# taxon
# platform

# files need to be in fastq.gz format. If its paired ended, the files need to be named with _1 and _2, e.g. mysample_1.fastq.gz and mysample_2.fastq.gz

=head1 NAME

Spreadsheet.pm   - Main driver class which pulls everything together to allow for a spreadsheet to be parsed, validated, converted to filemetadata objects and loaded into the pipeline


=head1 SYNOPSIS

use UpdatePipeline::Spreadsheet;
my $spreadsheet = UpdatePipeline::Spreadsheet->new(
  filename           => 't/data/external_data_example.xls',
  dont_use_warehouse => 1,
  common_name_required => 0,
  _vrtrack    => $vrtrack,
  study_names => [],
);
$spreadsheet->update();

=cut

package UpdatePipeline::Spreadsheet;
use Moose;
use Try::Tiny;
use UpdatePipeline::Exceptions;
use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetMetaData;
extends "UpdatePipeline::UpdateAllMetaData";

has 'filename'              => ( is => 'ro', isa => 'Str',      required => 1 );
has '_files_metadata'       => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

has '_sample_name_to_ssid'  => ( is => 'rw', isa => 'HashRef', default => sub{{}} );
has '_library_name_to_ssid' => ( is => 'rw', isa => 'HashRef', default => sub{{}} );
has '_study_name_to_ssid'   => ( is => 'rw', isa => 'HashRef', default => sub{{}} );

sub _build__files_metadata
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
  $self->_populate_files_metadata_with_dummy_ssids($spreadsheet_metadata->files_metadata);
  return $spreadsheet_metadata->files_metadata;
}

sub _populate_files_metadata_with_dummy_ssids
{
  my ($self, $files_metadata) = @_;
  
  for my $file_metadata (@{$files_metadata})
  {
    $file_metadata->study_ssid($self->_study_ssid($file_metadata->study_name));
    $file_metadata->library_ssid($self->_library_ssid($file_metadata->library_name));
    $file_metadata->sample_ssid($self->_sample_ssid($file_metadata->sample_name));
  }

  return $self;
}
  
sub _study_ssid
{
  my ($self, $studyname) = @_;
  
  return $self->_study_name_to_ssid->{$studyname} if(defined($self->_study_name_to_ssid->{$studyname}));
  
  my $vproject = VRTrack::Project->new_by_name( $self->_vrtrack, $studyname );
  if(defined($vproject) && defined($vproject->ssid))
  {
    $self->_study_name_to_ssid->{$studyname} = $vproject->ssid;
    return $vproject->ssid;
  }
  
  my $max_ssid = $self->_max_value_in_hash($self->_study_name_to_ssid) || 0;
  my $next_ssid =  $self->_next_ssid('project');
  if($max_ssid +1 > $next_ssid )
  {
    $next_ssid = $max_ssid +1;
  }

  $self->_study_name_to_ssid->{$studyname} = $next_ssid;
  
  return $next_ssid;
}


sub _library_ssid
{
  my ($self, $libraryname) = @_;
  
  return $self->_library_name_to_ssid->{$libraryname} if(defined($self->_library_name_to_ssid->{$libraryname}));

  my $vrobj = VRTrack::Library->new_by_name( $self->_vrtrack, $libraryname );
  if(defined($vrobj) && defined($vrobj->ssid))
  {
    $self->_library_name_to_ssid->{$libraryname} =$vrobj->ssid;
    return $vrobj->ssid;
  }
  
  my $max_ssid = $self->_max_value_in_hash($self->_library_name_to_ssid) || 0;
  my $next_ssid =  $self->_next_ssid('library');
  if($max_ssid +1 > $next_ssid )
  {
    $next_ssid = $max_ssid +1;
  }

  $self->_library_name_to_ssid->{$libraryname} = $next_ssid;
  
  return $next_ssid;
}

sub _sample_ssid
{
  my ($self, $samplename) = @_;
  
  return $self->_sample_name_to_ssid->{$samplename} if(defined($self->_sample_name_to_ssid->{$samplename}));
  
  my $sth = $self->_vrtrack->{_dbh}->prepare("select * from latest_sample where name ='$samplename'");
  $sth->execute();
  my $vsample = $sth->fetchrow_hashref();

  if(defined($vsample) && defined($vsample->{ssid}))
  {
    $self->_sample_name_to_ssid->{$samplename} = $vsample->{ssid};
    return $vsample->{ssid};
  }
  
  my $max_ssid = $self->_max_value_in_hash($self->_sample_name_to_ssid) ||0;
  my $next_ssid =  $self->_next_ssid('sample');
  if($max_ssid +1 > $next_ssid )
  {
    $next_ssid = $max_ssid +1;
  }

  $self->_sample_name_to_ssid->{$samplename} = $next_ssid;
  
  return $next_ssid;
}

sub _next_ssid
{
  my ($self,$table_name) = @_;
  my $sth = $self->_vrtrack->{_dbh}->prepare('select MAX(ssid) as max_ssid from '.$table_name);
  $sth->execute();
  my $result = $sth->fetchrow_hashref();
  return ($result->{max_ssid} + 1);
}
  
sub _max_value_in_hash
{
  my ($self,$search_hash) = @_;
  my @sorted_values = reverse(sort(values(%{$search_hash})));
  return $sorted_values[0];
}


1;