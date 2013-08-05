package UpdatePipeline::Spreadsheet::SpreadsheetValidatator::SequencingExperiment;
use Moose;
use Scalar::Util qw(looks_like_number);

has 'experiment_row'           => ( is => 'ro', isa => 'HashRef',    required => 1);
has 'valid_experiment_row'     => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_cell_title'              => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_cell_allowed_status'     => ( is => 'ro', isa => 'HashRef',    lazy_build => 1);
has '_filename'                => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_mate_filename'           => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_sample_name'             => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_sample_accession_number' => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_taxon_id'                => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_library_name'            => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);
has '_fragment_size'           => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_raw_read_count'          => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_raw_base_count'          => ( is => 'ro', isa => 'Maybe[Int]', lazy_build => 1);
has '_comments'                => ( is => 'ro', isa => 'Maybe[Str]', lazy_build => 1);

sub _build_valid_experiment_row
{
    my ($self) = @_;
    my %experiment_row = ( 'filename'                => $self->_filename,
                           'mate_filename'           => $self->_mate_filename,
                           'sample_name'             => $self->_sample_name,
                           'sample_accession_number' => $self->_sample_accession_number,
                           'taxon_id'                => $self->_taxon_id,
                           'library_name'            => $self->_library_name,
                           'fragment_size'           => $self->_fragment_size,
                           'raw_read_count'          => $self->_raw_read_count,
                           'raw_base_count'          => $self->_raw_base_count,
                           'comments'                => $self->_comments );
    return \%experiment_row;
}

sub _build__cell_title
{
    my ($self) = @_;
    my %cell = ( 'filename'                => 'Filename',
                 'mate_filename'           => 'Mate Filename',
                 'sample_name'             => 'Sample Name',
                 'sample_accession_number' => 'Sample Accession',
                 'taxon_id'                => 'Taxon ID',
                 'library_name'            => 'Library Name',
                 'fragment_size'           => 'Fragment Size',
                 'raw_read_count'          => 'Read Count',
                 'raw_base_count'          => 'Base Count',
                 'comments'                => 'Comments' );
    return \%cell;
}


sub _build__cell_allowed_status
{
    my ($self) = @_;
    my %cell = ( 'filename'                => ['string'],
                 'mate_filename'           => ['string','undefined','blank'],
                 'sample_name'             => ['string','integer'],
                 'sample_accession_number' => ['string','undefined'],
                 'taxon_id'                => ['integer'],
                 'library_name'            => ['string', 'integer'],
                 'fragment_size'           => ['integer','zero','undefined'],
                 'raw_read_count'          => ['integer','undefined'],
                 'raw_base_count'          => ['integer','undefined'],
                 'comments'                => ['string', 'undefined','blank'] );
    return \%cell;
}

sub _build__filename
{
    my ($self) = @_;
    print "\n";
    $self->_process_cell('filename');
    return $self->_process_filename('filename');
}

sub _build__mate_filename
{
    my ($self) = @_;
    $self->_process_cell('mate_filename');
    return $self->_process_filename('mate_filename') if defined $self->experiment_row->{'mate_filename'};

    return undef; # no mate filename
}

sub _build__sample_name
{
    my ($self) = @_;
    return $self->experiment_row->{'sample_name'} if $self->_process_cell('sample_name');

    print " fatal error: sample name not present.\n" unless defined $self->experiment_row->{'sample_name'};
    return $self->experiment_row->{'sample_name'};
}

sub _build__sample_accession_number
{
    my ($self) = @_;
    $self->_process_cell('sample_accession_number');
    return $self->experiment_row->{'sample_accession_number'};
}

sub _build__taxon_id
{
    my ($self) = @_;
    return $self->experiment_row->{'taxon_id'} if $self->_process_cell('taxon_id');
    
    print " fatal error: taxon id is not an integer.\n";
    return undef;
}

sub _build__library_name
{
    my ($self) = @_;
    return $self->experiment_row->{'library_name'} if $self->_process_cell('library_name');

    print " fatal error: library name not present.\n" unless defined $self->experiment_row->{'library_name'};
    return $self->experiment_row->{'library_name'};
}

sub _build__fragment_size
{
    my ($self) = @_;
    return $self->experiment_row->{'fragment_size'} if $self->_process_cell('fragment_size');

    my $fragment_size = $self->experiment_row->{'fragment_size'};
    print ' fragment size is ',$fragment_size;
    if($self->_get_cell_status('fragment_size') eq 'string')
    {
        $fragment_size =~ s/\s+//gi; # remove space
        $fragment_size =~ s/bp$//gi; # remove bp
    }
    $fragment_size = undef if $fragment_size eq '';
    print ' - fragment size set to ',defined($fragment_size) ? $fragment_size:'undef',"\n";

    return $fragment_size;
}

sub _build__raw_read_count
{
    my ($self) = @_;
    $self->_process_cell('raw_read_count');
    return $self->experiment_row->{'raw_read_count'};
}

sub _build__raw_base_count
{
    my ($self) = @_;
    $self->_process_cell('raw_base_count');
    return $self->experiment_row->{'raw_base_count'};
}

sub _build__comments
{
    my ($self) = @_;
    $self->_process_cell('comments');
    return $self->experiment_row->{'comments'};
}

sub _get_cell_status
{
    my ($self,$cell) = @_;

    my $status = '';
    if(! exists  $self->experiment_row->{$cell})
    { 
        $status = "absent"; 
    }
    elsif(! defined $self->experiment_row->{$cell})
    { 
        $status = "undefined"; 
    }
    elsif($self->experiment_row->{$cell} eq '' )
    { 
        $status = "blank"; 
    }
    elsif( looks_like_number $self->experiment_row->{$cell} )
    { 
        $status = "number";
        $status = "integer" if $self->experiment_row->{$cell} =~ m/^\d+$/;
        $status = "zero"    if $self->experiment_row->{$cell} == 0;
    }
    elsif( $self->experiment_row->{$cell} =~ m/^\d{2}\.\d{2}\.\d{4}$/ )
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

sub _process_filename
{
    my ($self,$cell) = @_;
    my $file = $self->experiment_row->{$cell};

    if($file =~ m/^\s+|\s+$/gi)
    {
        print " removing leading/trailing whitespace from '$file'\n";
        $file =~ s/^\s+|\s+$//gi;
    }

    if($file =~ m/\//gi)
    {
        print " removing path from '$file'\n";
        my @path = split(/\//,$file);
        $file = pop @path;
        print " Filename is '$file'\n";
    }

    print " error: no filename found in cell\n" if $file eq '';

    return $file;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
