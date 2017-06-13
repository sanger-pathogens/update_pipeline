package UpdatePipeline::CommonDatabaseSetup;

# ABSTRACT: Common database setup

use Moose::Role;
use MLWarehouse::Database;
use Pathogens::ConfigSettings;

has '_ml_warehouse_dbh' => ( is => 'rw', lazy_build => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has '_database_settings'            => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has 'environment'                   => ( is => 'rw', isa => 'Str', default => 'production');


sub _build__ml_warehouse_dbh
{
  my ($self) = @_;
  MLWarehouse::Database->new(settings => $self->_database_settings->{ml_warehouse})->connect;
 
}

sub _build__database_settings
{
  my ($self) = @_;
  \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'database.yml')->settings()};
}

sub _set_database_auto_reconnect
{
  my ($self) = @_;
  $self->_ml_warehouse_dbh->{mysql_auto_reconnect}   = 1; # required for validating large databases
  $self->_vrtrack->{_dbh}->{mysql_auto_reconnect} = 1;
}

1;
