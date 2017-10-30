package MLWarehouse::IseqRunLaneMetrics;

# ABSTRACT: Take a run ID and look up the insert size 

=head1 SYNOPSIS

use MLWarehouse::IseqRunLaneMetrics;
my $file = MLWarehouse::IseqRunLaneMetrics->new(
  file_meta_data => $filemetadata,
  _dbh => $warehouse_dbh
  );

$file->populate();

=cut
use Moose;

has 'file_meta_data' => ( is => 'rw', isa => 'UpdatePipeline::CommonFileMetaData', required => 1 );
has '_dbh'           => ( is => 'rw',                                        required => 1 );
has '_id_run'        => ( is => 'rw', isa => 'Int');
has '_position'      => ( is => 'rw', isa => 'Int');
has '_tag'           => ( is => 'rw', isa => 'Int');

sub populate
{
  my($self) = @_;
  return 0 if(! defined($self->file_meta_data->file_name_without_extension));
  return 0 if(! ($self->file_meta_data->file_name_without_extension =~ /#/));
  $self->_split_file_name;
  
  if( ! defined($self->file_meta_data->run_date()))
  {
	  $self->_populate_run_complete_from_iseq_product_metrics();
  }
  
  1;
}

sub _populate_run_complete_from_iseq_product_metrics
{
  my($self) = @_;
  if(defined($self->_id_run) && defined($self->_position) && defined($self->_tag)  )
  {
    my $id_run = $self->_id_run;
    my $position = $self->_position;
    my $tag = $self->_tag;
    
    my $sql = qq[select run_complete from iseq_run_lane_metrics where id_run = "$id_run" AND position = $position  AND run_complete is not NULL limit 1;];
    my $sth = $self->_dbh->prepare($sql);
    $sth->execute;
    my @study_warehouse_details  = $sth->fetchrow_array;
    if(@study_warehouse_details > 0)
    {
      $self->file_meta_data->run_date($study_warehouse_details[0])   if(!defined($self->file_meta_data->run_date));
    }
  }
}

sub _split_file_name
{
  my($self) = @_;
  if($self->file_meta_data->file_name_without_extension =~ /^([\d]+)_([\d]+)#([\d]+)$/)
  {
    $self->_id_run($1);
    $self->_position($2);
    $self->_tag($3);
  }
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
