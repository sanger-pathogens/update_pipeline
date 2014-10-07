package NCBI::Exceptions;
# ABSTRACT: Exceptions for looking up NCBI
use Exception::Class (
    NCBI::Exceptions::TaxonLookupFailed   => { description => 'Couldnt lookup the scientific name from a taxon id' },
);  
use Moose;

__PACKAGE__->meta->make_immutable;

no Moose;

1;
