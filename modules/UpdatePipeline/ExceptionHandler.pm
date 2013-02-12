=head1 NAME

ExceptionHandler.pm   - Consume all exceptions, take action and report

=head1 SYNOPSIS

use UpdatePipeline::ExceptionHandler;
my $exception_handler = UpdatePipeline::ExceptionHandler->new();

$exception_handler->add_exception($exception);
$exception_handler->add_exception($exception);
....

$exception_handler->print_report();

=cut

package UpdatePipeline::ExceptionHandler;
use Moose;
use UpdatePipeline::Exceptions;
use UpdatePipeline::ExceptionReporter;
use UpdatePipeline::VRTrack::ExceptionHandling::Lane;
use UpdatePipeline::VRTrack::ExceptionHandling::File;

has '_exception_reporter' => ( is => 'rw', isa => 'UpdatePipeline::ExceptionReporter', lazy_build => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has 'minimum_run_id'      => ( is => 'rw', isa => 'Int');
has 'update_if_changed'   => ( is => 'rw', isa => 'Bool', default    => 0 );

sub _build__exception_reporter
{
  my ($self) = @_;
  UpdatePipeline::ExceptionReporter->new( _vrtrack => $self->_vrtrack); 
}

sub add_exception
{
  my($self, $exception, $filename) = @_;
  if(defined($self->minimum_run_id))
  {
    if( $filename =~ m/^(\d+)_/)
    {
      return 1 if( $1 < $self->minimum_run_id);
    }
  }
  $self->_exception_reporter->add_exception($exception);

  if($exception->isa("UpdatePipeline::Exceptions::PathToLaneChanged") && $self->update_if_changed == 1)
  {
    $self->_delete_lane($exception);
    $self->_delete_files($exception);
  }
  1;
}

sub print_report
{
  my($self, $print_unclassified) = @_;
  $self->_exception_reporter->print_report($print_unclassified);
}

# the path to a lane has changed so delete the lane so that it will be reimported in the next run of the importer
sub _delete_lane
{
  my($self,$exception) = @_;
  my $lane_exception_handler =  UpdatePipeline::VRTrack::ExceptionHandling::Lane->new(_vrtrack  => $self->_vrtrack, name => $exception->error);
  $lane_exception_handler->delete_lane();
}

sub _delete_files
{
  my($self,$exception) = @_;
  my $lane_exception_handler =  UpdatePipeline::VRTrack::ExceptionHandling::File->new(_vrtrack  => $self->_vrtrack, name => $exception->error);
  $lane_exception_handler->delete_files();
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
