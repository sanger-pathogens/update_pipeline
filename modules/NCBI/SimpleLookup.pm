=head1 NAME

SimpleLookup.pm   - Given an NCBI taxon ID, lookup the common name

=head1 SYNOPSIS

use NCBI::SimpleLookup;
my $taxon_lookup = NCBI::SimpleLookup->new(taxon_id => 9606);
$taxon_lookup->common_name;


=cut

package NCBI::SimpleLookup;

use Moose;
use Bio::DB::EUtilities;

has 'taxon_id'             => ( is => 'ro', isa => 'Int', required => 1 );
has 'common_name'          => ( is => 'ro', isa => 'Str', lazy_build => 1 );
has 'environment'      => ( is => 'ro', isa => 'Str', default => 'production' );
has '_config_settings' => ( is => 'ro', isa => 'HashRef', lazy_build => 1 );

sub _build__config_settings {
    my ($self) = @_;
    return \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}

sub _build_common_name
{
    my ($self) = @_;
    my $user_email;
    if (defined $self->_config_settings->{'email_eutils'} ) {
    	$user_email = $self->_config_settings->{'email_eutils'};
    }
    else {
    	$user_email = 'foo_bar@sanger.ac.uk';
    }
    my $factory = Bio::DB::EUtilities->new(-eutil => 'esummary', -email => $user_email, -db => 'taxonomy', -id => $self->taxon_id);
    my ($common_name) = $factory->next_DocSum->get_contents_by_name('ScientificName');
    return $common_name;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
