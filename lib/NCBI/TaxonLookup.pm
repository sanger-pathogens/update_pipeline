package NCBI::TaxonLookup;

# ABSTRACT: Given a taxon find the common name

=head1 SYNOPSIS

use NCBI::TaxonLookup;
my $taxon_lookup = NCBI::TaxonLookup->new(taxon_id => 9606);
$taxon_lookup->common_name;

=cut

use Moose;
use LWP::UserAgent;
use XML::TreePP;
use URI::Escape;
use NCBI::Exceptions;

has 'taxon_id'             => ( is => 'ro', isa => 'Int', required => 1 );
has 'taxon_lookup_service' => ( is => 'ro', isa => 'Str', default  => 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=taxonomy&report=xml&id=' );

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
  my ($result);
  for (my $i=1; $i<=15; $i++) { 
    $result = eval {
      my $tpp = $self->_setup_xml_parser_via_proxy;
      my $tree = $tpp->parsehttp( GET => $url );
      (defined($tree->{TaxaSet}) && $tree->{TaxaSet} eq '')  ? '' : $tree->{TaxaSet}->{Taxon}->{ScientificName};
    };
    last if defined($result);
    my $random_number = int(rand(5)) + 1;
    sleep($random_number);
  }
  if (!defined($result) || $result eq "") {
    NCBI::Exceptions::TaxonLookupFailed ->throw( error => "Cant lookup the scientific name for taxon ID ".$self->taxon_id."\n" );
  }
  else {
    return $result;
  }
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
