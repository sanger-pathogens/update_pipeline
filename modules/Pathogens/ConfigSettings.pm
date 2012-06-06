=head1 NAME

ConfigSettings.pm   - Return configuration settings

=head1 SYNOPSIS

use Pathogens::ConfigSettings;
my %config_settings = %{Pathogens::ConfigSettings->new(environment => 'test')->settings()};

=cut

package Pathogens::ConfigSettings;

use Moose;
use File::Slurp;
use YAML::XS;

has 'environment' => (is => 'rw', isa => 'Str', default => 'test');
has 'filename' => ( is => 'rw', isa => 'Str', default => 'config.yml' );
has 'settings' => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );


sub _build_settings 
{
  my $self = shift;
  my %config_settings = %{ Load( scalar read_file("config/".$self->environment."/".$self->filename.""))};
  return \%config_settings;
} 

__PACKAGE__->meta->make_immutable;

no Moose;

1;
