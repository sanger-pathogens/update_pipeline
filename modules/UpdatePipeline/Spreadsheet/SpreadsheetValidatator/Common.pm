package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::Common;
use Moose;
use Scalar::Util qw(looks_like_number);

has '_cell_data'           => ( is => 'ro', isa => 'HashRef', lazy_build => 1);
has '_cell_title'          => ( is => 'ro', isa => 'HashRef', lazy_build => 1);
has '_cell_allowed_status' => ( is => 'ro', isa => 'HashRef', lazy_build => 1);

sub _get_cell_status
{
    my ($self,$cell) = @_;

    my $status = '';
    if(! exists  $self->_cell_data->{$cell})
    { 
        $status = "absent"; 
    }
    elsif(! defined $self->_cell_data->{$cell})
    { 
        $status = "undefined"; 
    }
    elsif($self->_cell_data->{$cell} eq '' )
    { 
        $status = "empty"; 
    }
    elsif($self->_cell_data->{$cell} =~ m/^\s+$/ )
    { 
        $status = "blank"; 
    }
    elsif( looks_like_number $self->_cell_data->{$cell} )
    { 
        $status = "number";
        $status = "integer" if $self->_cell_data->{$cell} =~ m/^\d+$/;
        $status = "zero"    if $self->_cell_data->{$cell} == 0;
    }
    elsif( $self->_cell_data->{$cell} =~ m/^\d{2}\.\d{2}\.\d{4}$/ )
    {
        $status = "date"; 
    }
    else
    {
        $status = "string";
    }

    return $status;
}

sub _process_cell
{
    my ($self,$cell) = @_;

    my $title   = $self->_cell_title->{$cell};
    my $status  = $self->_get_cell_status($cell);
    my %allowed = map { $_ => 1 } @{$self->_cell_allowed_status->{$cell}};

    my $passed  = $allowed{$status} ? 'ok':'error' ;
    printf "%-22s is %-9s %s\n",$title,$status,$passed;

    return $allowed{$status};
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
