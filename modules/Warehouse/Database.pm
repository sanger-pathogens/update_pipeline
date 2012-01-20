package Warehouse::Database;
use Moose;

has 'settings'   => ( is => 'rw', isa => 'HashRef', required   => 1 );

sub connect
{
  my ($self) = @_;
 # connect to the database
}

1;