package NCBI::Exceptions;

use Exception::Class (
    NCBI::Exceptions::TaxonLookupFailed   => { description => 'Couldnt lookup the scientific name from a taxon id' },
);  

__PACKAGE__->meta->make_immutable;

no Moose;

1;
