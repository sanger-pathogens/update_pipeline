package Warehouse::Database;
use Moose;
use DBI;
use DBD::mysql;
has 'settings'   => ( is => 'rw', isa => 'HashRef', required   => 1 );

sub connect
{
  my ($self) = @_;
  my $name = $self->settings->{database};
  my $host = $self->settings->{host};
  my $port = $self->settings->{port};
  my $user = $self->settings->{user};
  DBI->connect(
    "DBI:mysql:host=$host:port=$port;database=$name", 
    $user, undef, {'RaiseError' => 1, 'PrintError'=>0});
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
