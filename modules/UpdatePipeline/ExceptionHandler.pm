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

has '_exception_reporter' => ( is => 'rw', isa => 'UpdatePipeline::ExceptionReporter', lazy_build => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );

sub _build__exception_reporter
{
  my ($self) = @_;
  UpdatePipeline::ExceptionReporter->new( _vrtrack => $self->_vrtrack); 
}

sub add_exception
{
  my($self, $exception) = @_;
  $self->_exception_reporter->add_exception($exception);

  if($exception->isa("UpdatePipeline::Exceptions::PathToLaneChanged"))
  {
    $self->_delete_lane($exception);
  }
  1;
}

sub print_report
{
  my($self) = @_;
  $self->_exception_reporter->print_report
}

# the path to a lane has changed so delete the lane so that it will be reimported in the next run of the importer
sub _delete_lane
{
  my($self,$exception) = @_;
  my $lane_exception_handler =  UpdatePipeline::VRTrack::ExceptionHandling::Lane->new(_vrtrack  => $self->_vrtrack, name => $exception->error);
  $lane_exception_handler->delete_lane();
}

1;