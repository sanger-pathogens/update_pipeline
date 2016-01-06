package UpdatePipeline::CommonDatabaseSetup;

# ABSTRACT: Common database setup

use Moose::Role;
use GCLPWarehouse::Database;
use Warehouse::Database;
use Pathogens::ConfigSettings;

has '_warehouse_dbh'      => ( is => 'rw', lazy_build => 1 );
has '_gclp_warehouse_dbh' => ( is => 'rw', lazy_build => 1 );
has '_vrtrack'            => ( is => 'rw', required => 1 );
has '_database_settings'            => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has 'environment'                   => ( is => 'rw', isa => 'Str', default => 'production');


sub _build__warehouse_dbh
{
  my ($self) = @_;
  Warehouse::Database->new(settings => $self->_database_settings->{warehouse})->connect;
  
}

sub _build__gclp_warehouse_dbh
{
  my ($self) = @_;
  GCLPWarehouse::Database->new(settings => $self->_database_settings->{gclp_warehouse})->connect;
 
}

sub _build__database_settings
{
  my ($self) = @_;
  \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'database.yml')->settings()};
}

sub _set_database_auto_reconnect
{
  my ($self) = @_;
  $self->_warehouse_dbh->{mysql_auto_reconnect}   = 1; # required for validating large databases
  $self->_gclp_warehouse_dbh->{mysql_auto_reconnect}   = 1; # required for validating large databases
  $self->_vrtrack->{_dbh}->{mysql_auto_reconnect} = 1;
}

1;
