=head1 NAME

TaxonLookup.pm   - Given an NCBI taxon ID, lookup the common name

=head1 SYNOPSIS

use NCBI::TaxonLookup;
my $taxon_lookup = NCBI::TaxonLookup->new(taxon_id => 9606);
$taxon_lookup->common_name;


=cut

package NCBI::TaxonLookup;

use Moose;
use LWP::UserAgent;
use XML::TreePP;
use URI::Escape;
use NCBI::Exceptions;

has 'taxon_id'             => ( is => 'ro', isa => 'Int', required => 1 );
has 'taxon_lookup_service' => ( is => 'ro', isa => 'Str', default  => 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&report=xml&id=' );

has 'common_name' => ( is => 'ro', isa => 'Str', lazy_build => 1 );

sub _build_common_name
{
  my ($self) = @_;
  my $full_query = $self->taxon_lookup_service.$self->taxon_id;
  
  my $common_name = $self->_local_lookup_translation_table($full_query);
  unless(defined($common_name))
  {
    $common_name = $self->_remote_lookup_translation_table($full_query);
  }
  return $common_name;
}


sub _local_lookup_translation_table
{
  my ($self, $file) = @_;
  return undef unless (-e $file);
  
  my $tpp = XML::TreePP->new();
  my $tree = $tpp->parsefile( $file );
  $tree->{TaxaSet}->{Taxon}->{ScientificName};
}

sub _remote_lookup_translation_table
{
  my ($self, $url) = @_;
  
  eval {
    my $tpp = $self->_setup_xml_parser_via_proxy;
    my $tree = $tpp->parsehttp( GET => $url );
    $tree->{TaxaSet}->{Taxon}->{ScientificName};
  } or do
  {
     NCBI::Exceptions::TaxonLookupFailed ->throw( error => "Cant lookup the scientific name for taxon ID ".$self->taxon_id."\n" );
  };
}

sub _setup_xml_parser_via_proxy
{
  my ($self) = @_;
  my $tpp = XML::TreePP->new();
  my $ua = LWP::UserAgent->new();
  $ua->timeout( 60 );
  $ua->env_proxy;
  $tpp->set( lwp_useragent => $ua );
  $tpp;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
