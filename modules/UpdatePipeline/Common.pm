package UpdatePipeline::Common;
use Moose;


sub array_contains_value 
{
    my(@array_with_values)  = @_;
    for my $array_value (@array_with_values)
    {
      if($array_value)
      {
        return 1;
      }
    }
    return 0;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
