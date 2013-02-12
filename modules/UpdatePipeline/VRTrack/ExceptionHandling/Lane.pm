=head1 NAME

Lane.pm   - Fix a lane when there is an exception. Just sets latest = 0 for a given name

=head1 SYNOPSIS

use UpdatePipeline::VRTrack::ExceptionHandling::Lane;
my $lane_exception_handler = UpdatePipeline::VRTrack::ExceptionHandling::Lane->new(
  name         => '1234_5#6',
  _vrtrack     => $vrtrack_dbh,
  );
$lane_exception_handler->delete_lane();

=cut


package UpdatePipeline::VRTrack::ExceptionHandling::Lane;
use VRTrack::Lane;
use Moose;

has 'name'      => ( is => 'rw', isa => 'Str',  required   => 1 );
has '_vrtrack'  => ( is => 'rw', required => 1 );

sub delete_lane
{
  my($self)= @_;
  my $search_query = $self->name;  
  my $lane_sql = qq[update latest_lane set latest = 0 where name="$search_query" or hierarchy_name="$search_query" limit 1];
  $self->_vrtrack->{_dbh}->do($lane_sql);
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
