=head1 NAME

Header.pm  - Validator for a spreadsheet header. Takes in the values as a hash and returns true or false

=head1 SYNOPSIS

# in a Moose class
use UpdatePipeline::Spreadsheet::Validate::Header;

subtype 'Header'
     => as 'HashRef'
     => where { UpdatePipeline::Spreadsheet::Validate::Header->new( input_header => $_ )->is_valid() }
     => message { "$_ is not a valid Header" };

has 'input_header'   => ( is => 'ro', isa => 'Header', required   => 1 );

=cut

package UpdatePipeline::Spreadsheet::Validate::Header;
use Moose;
use Try::Tiny;
use UpdatePipeline::Spreadsheet::HeaderMetaData;

has 'input_header' => ( is => 'ro', isa => 'HashRef', required   => 1 );

sub is_valid
{
  my ($self) = @_;
  
  return try{
    UpdatePipeline::Spreadsheet::HeaderMetaData->new($self->input_header);
    1;
  }
  catch{
    0;
  };
  
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
