package Pathogens::ConfigSettings;

# ABSTRACT: Config file parsing 

=head1 SYNOPSIS

use Pathogens::ConfigSettings;
my %config_settings = %{Pathogens::ConfigSettings->new(environment => 'test')->settings()};

=cut
use Moose;
use File::Slurp;
use YAML::XS;

has 'environment' => (is => 'rw', isa => 'Str', default => 'test');
has 'filename' => ( is => 'rw', isa => 'Str', default => 'config.yml' );
has 'settings' => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );


sub _build_settings 
{
  my $self = shift;
  my $directory = (defined $ENV{'UPDATE_PIPELINE_CONFIG_PATH'}) ? $ENV{'UPDATE_PIPELINE_CONFIG_PATH'} : "config/" . $self->environment ;
  
  my %config_settings = %{ Load( scalar read_file($directory . "/" . $self->filename.""))};
  return \%config_settings;
} 

__PACKAGE__->meta->make_immutable;

no Moose;

1;
