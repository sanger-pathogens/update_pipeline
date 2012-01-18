package UpdatePipeline::CommonSettings;
use Pathogens::ConfigSettings;
use Moose;

has 'environment'                   => ( is => 'rw', isa => 'Str', default => 'production');
has '_config_settings'              => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );
has '_database_settings'            => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );


sub _build__config_settings
{
   my ($self) = @_;
   \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}

sub _build__database_settings
{
  my ($self) = @_;
  \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'database.yml')->settings()};
}
1;