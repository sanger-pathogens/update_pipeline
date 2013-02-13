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
  files_base_directory => '/path/to/files/to/add',
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
use File::Copy;
use File::Path qw(make_path  );
use Parallel::ForkManager;
use Digest::MD5;
use UpdatePipeline::Exceptions;
use UpdatePipeline::Spreadsheet::Parser;
use UpdatePipeline::Spreadsheet::SpreadsheetMetaData;
extends "UpdatePipeline::UpdateAllMetaData";

has 'filename'                => ( is => 'ro', isa => 'Str',      required => 1 );
has 'files_base_directory'    => ( is => 'ro', isa => 'Maybe[Str]');
has 'pipeline_base_directory' => ( is => 'ro', isa => 'Maybe[Str]');
has 'parallel_processes'      => ( is => 'ro', isa => 'Int',    default => 4);


has '_files_metadata'       => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

has '_sample_name_to_ssid'  => ( is => 'rw', isa => 'HashRef',  default => sub{{}} );
has '_library_name_to_ssid' => ( is => 'rw', isa => 'HashRef',  default => sub{{}} );
has '_study_name_to_ssid'   => ( is => 'rw', isa => 'HashRef',  default => sub{{}} );

has '_spreadsheet_metadata' => ( is => 'rw', isa => 'Maybe[UpdatePipeline::Spreadsheet::SpreadsheetMetaData]');
has 'hierarchy_template'    => ( is => 'rw', isa => 'Str',      default => "genus:species-subspecies:TRACKING:projectssid:sample:technology:library:lane" );
has '_rsync'                => ( is => 'rw', isa => 'File::RsyncP', lazy_build => 1 );

sub _build__rsync
{
  my ($self) = @_;
  File::RsyncP->new();
}

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
      input_header         => $parser->header_metadata,
      raw_rows             => $parser->rows_metadata,
      files_base_directory => $self->files_base_directory
    );
  }
  catch
  {
     UpdatePipeline::Exceptions::InvalidSpreadsheetMetaData->throw( error =>  "The data in the spreadsheet is invalid");
  };
  $self->_populate_files_metadata_with_dummy_ssids($spreadsheet_metadata->files_metadata);
  $self->_spreadsheet_metadata($spreadsheet_metadata);
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
  return 1 unless(defined($result) && defined($result->{max_ssid}));
  return ($result->{max_ssid} + 1);
}
  
sub _max_value_in_hash
{
  my ($self,$search_hash) = @_;
  my @sorted_values = reverse(sort(values(%{$search_hash})));
  return $sorted_values[0];
}


# TODO: use RSYNC module instead of shelling out
sub import_sequencing_files_to_pipeline
{
   my ($self) = @_;
   return unless(defined($self->files_base_directory));
   my @files_source_and_dest; 
   
   
   for my $sequencing_experiment (@{$self->_spreadsheet_metadata->_sequencing_experiments})
   {
     my $vlane = VRTrack::Lane->new_by_name( $self->_vrtrack, $self->_spreadsheet_metadata->_file_name_without_extension($sequencing_experiment->filename,'fastq.gz'));
     my $lane_path = $self->_vrtrack->hierarchy_path_of_lane($vlane,$self->hierarchy_template);
     my $target_directory = join('/',($self->pipeline_base_directory,$lane_path));
     make_path($target_directory , {mode => 0775});
     
     my $target_file = join('/',($target_directory,$sequencing_experiment->pipeline_filename ));
     my $source_file = $sequencing_experiment->file_location_on_disk;
     my @source_and_dest = ($source_file,$target_file );
     push(@files_source_and_dest, \@source_and_dest);
     
     $self->_update_md5_of_file_in_database($vlane, $sequencing_experiment->pipeline_filename,$source_file, $target_file );
     
     if(defined($sequencing_experiment->mate_filename))
     {
       my $target_mate_file = join('/',($target_directory, $sequencing_experiment->pipeline_mate_filename));
       my $source_mate_file =$sequencing_experiment->mate_file_location_on_disk;
       my @mate_source_and_dest = ($source_mate_file,$target_mate_file );
       push(@files_source_and_dest, \@mate_source_and_dest);
       
       $self->_update_md5_of_file_in_database($vlane, $sequencing_experiment->pipeline_mate_filename,$source_mate_file,$target_mate_file );

     }
   }
   
   $self->_copy_files(\@files_source_and_dest);
   $self->_vrtrack->{_dbh}->{mysql_auto_reconnect} = 1;
   
   for my $sequencing_experiment (@{$self->_spreadsheet_metadata->_sequencing_experiments})
   {
     my $vlane = VRTrack::Lane->new_by_name( $self->_vrtrack, $self->_spreadsheet_metadata->_file_name_without_extension($sequencing_experiment->filename,'fastq.gz'));
     $vlane->is_processed('import',1);
     $vlane->update();
   }
   
   return 1;
}

sub _copy_files
{
   my ($self, $files_source_and_dest) = @_;
   my $pm = new Parallel::ForkManager($self->parallel_processes); 
   for my $file_source_and_dest (@{$files_source_and_dest})
   {
     $pm->start and next; # do the fork
     my $source_file = $file_source_and_dest->[0];
     my $target_file = $file_source_and_dest->[1];
     `rsync $source_file $target_file`;
     
     # create fastqcheck file from the original file
     `gunzip -c $source_file | sed 's/ /_/g' | fastqcheck > $target_file.fastqcheck`;
     
     $pm->finish; # do the exit in the child process
   }
   $pm->wait_all_children;
}

sub _update_md5_of_file_in_database
{
   my ($self,$vlane, $pipeline_filename, $source_file, $target_file) = @_;
   
   for my $vfile (@{$vlane->files})
   {
     my $expected_name = $pipeline_filename;
     if($vfile->name =~ /$expected_name/)
     {
       my $md5_of_gzip_file = $self->_calculate_md5_of_gzip_file($source_file);
       
       # save to DB
       $vfile->md5($md5_of_gzip_file);
       $vfile->update();
       
       # write it out to disk
       open(OUT, "+>".$target_file.'.md5');
       print OUT $md5_of_gzip_file."  ".$source_file."";
       close(OUT);
       
       return;
     }
   }
}

sub _calculate_md5_of_gzip_file
{
  my ($self,$input_file) = @_;
  open(my $input_gzip_file_handle, '-|', "gunzip -c ".$input_file);
  my $md5 = Digest::MD5->new();
  $md5->addfile($input_gzip_file_handle);
  return $md5->hexdigest;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
