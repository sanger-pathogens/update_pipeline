package IRODS::Common;
use Moose;

has 'bin_directory' => (isa => 'Str', is => 'rw', default => '/software/irods/icommands/bin/');

__PACKAGE__->meta->make_immutable;

no Moose;

1;
