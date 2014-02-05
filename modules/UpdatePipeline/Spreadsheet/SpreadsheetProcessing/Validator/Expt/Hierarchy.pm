package UpdatePipeline::Spreadsheet::SpreadsheetProcessing::Validator::Expt::Hierarchy;

use Moose;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameNotUnique;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::LibraryToSample;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleToTaxonID;
use UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleToAccession;

has 'rows_metadata' => ( is => 'ro', isa => 'ArrayRef', required   => 1 );
has 'error_list'    => ( is => 'ro', isa => 'ArrayRef', lazy_build => 1 );

sub _build_error_list
{
    my ($self) = @_;
    my @error_list = ();

    # Check hierarchy
    push @error_list, @{ $self->_unique_fastq };
    push @error_list, @{ $self->_library_to_sample };
    push @error_list, @{ $self->_sample_to_taxon };
    push @error_list, @{ $self->_sample_to_accession };

    return \@error_list;
}

sub _unique_fastq
{
    my ($self) = @_;
    my %fastq;
    my $row = 0;
    for my $expt (@{ $self->rows_metadata })
    {
        $row++;
        if(defined $expt->{'filename'} && $expt->{'filename'} ne '')
        {
            push @{$fastq{$expt->{'filename'}}},$row;
        }
    }

    my @error_list = ();
    for my $filename (sort keys %fastq)
    {
        if( @{ $fastq{$filename} } > 1 )
        {
            for my $row_num (@{ $fastq{$filename} })
            {
                push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::FilenameNotUnique->new( row => $row_num );
            }
        }
    }

    @error_list = sort {$a->row <=> $b->row } @error_list;
    return \@error_list;
}

sub _library_to_sample
{
    my ($self) = @_;
    my %library_to_sample;

    my $row = 0;
    for my $expt (@{ $self->rows_metadata })
    {
        $row++;
        if(defined $expt->{'library_name'} && $expt->{'library_name'} ne '' && defined $expt->{'sample_name'} && $expt->{'sample_name'} ne '')
        {
            push @{$library_to_sample{$expt->{'library_name'}}{$expt->{'sample_name'}}},$row;
        }
    }

    my @error_list = ();
    for my $library (sort keys %library_to_sample)
    {
        if ( scalar keys %{ $library_to_sample{$library} } > 1 )
        {
            # library maps to more than one sample
            for my $sample ( sort keys %{ $library_to_sample{$library} } )
            {
                for my $row_num (@{ $library_to_sample{$library}{$sample} })
                {
                    push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::LibraryToSample->new( row => $row_num );
                }
            }
        }
    }

    @error_list = sort {$a->row <=> $b->row } @error_list;
    return \@error_list;
}

sub _sample_to_taxon
{
    my ($self) = @_;
    my %sample_to_taxon;

    my $row = 0;
    for my $expt (@{ $self->rows_metadata })
    {
        $row++;
        if(defined $expt->{'sample_name'} && $expt->{'sample_name'} ne '' && defined $expt->{'taxon_id'} && $expt->{'taxon_id'} ne '')
        {
            push @{ $sample_to_taxon{$expt->{'sample_name'}}{$expt->{'taxon_id'}} },$row;
        }
    }

    my @error_list = ();
    for my $sample (sort keys %sample_to_taxon)
    {
        if( scalar keys %{ $sample_to_taxon{$sample} } > 1 )
        {
            # sample maps to more than one taxon id
            for my $taxon_id ( sort keys %{ $sample_to_taxon{$sample} } )
            {
                for my $row_num (@{ $sample_to_taxon{$sample}{$taxon_id} })
                {
                    push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleToTaxonID->new( row => $row_num );
                }
            }
        }
    }

    @error_list = sort {$a->row <=> $b->row } @error_list;
    return \@error_list;
}

sub _sample_to_accession
{
    my ($self) = @_;
    my %sample_to_accession;

    my $row = 0;
    for my $expt (@{ $self->rows_metadata })
    {
        $row++;
        if(defined $expt->{'sample_name'} && $expt->{'sample_name'} ne '' && defined $expt->{'sample_accession_number'} && $expt->{'sample_accession_number'} ne '')
        {
            push @{ $sample_to_accession{$expt->{'sample_name'}}{$expt->{'sample_accession_number'}} },$row;
        }
    }

    my @error_list = ();
    for my $sample (sort keys %sample_to_accession)
    {
        if ( scalar keys %{ $sample_to_accession{$sample} } > 1 )
        {
            # sample maps to more than one accession
            for my $accession ( sort keys %{ $sample_to_accession{$sample} } )
            {
                for my $row_num (@{ $sample_to_accession{$sample}{$accession} })
                {
                    push @error_list, UpdatePipeline::Spreadsheet::SpreadsheetProcessing::ErrorsAndWarnings::Error::SampleToAccession->new( row => $row_num );
                }
            }
        }
    }

    @error_list = sort {$a->row <=> $b->row } @error_list;
    return \@error_list;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;