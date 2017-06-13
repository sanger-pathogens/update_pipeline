package UpdatePipeline::PB::IRODS;

# ABSTRACT: Take in the name of a study and produce a metadata object for each experiment file

=head1 SYNOPSIS

Take in the name of a study and produce a metadata object for each experiment file. Lookup the warehouse, look for files in irods, look for metadata on each file.
   use UpdatePipeline::PB::IRODS;

   my $obj = UpdatePipeline::PB::IRODS->new(
       study_name        => 'ABC',
       dbh               => $dbh
     );
   $obj->files_metadata();

=cut

use Moose;
use UpdatePipeline::PB::FileMetaData;
use Scalar::Util qw(looks_like_number);

extends 'UpdatePipeline::IRODS';

has 'files_metadata'  => ( is => 'ro', isa      => 'ArrayRef', lazy => 1, builder => '_build_files_metadata' );
has 'file_type'       => ( is => 'ro', default  => 'h5', isa => 'Str' );

sub _build_files_metadata {
    my ($self) = @_;
    my @files_metadata;

    my @irods_files_metadata = @{ $self->_get_irods_file_metadata_for_studies() };

    for my $irods_file_metadata (@irods_files_metadata) {       
        my $file_metadata;
	
	next if(! defined($irods_file_metadata->{run}) || ! looks_like_number($irods_file_metadata->{run}));
        next if ( $irods_file_metadata->{run} < $self->specific_min_run );
	
	my $lane_name = $irods_file_metadata->{run};
        if(defined($irods_file_metadata->{run}) && defined($irods_file_metadata->{well}))
        {
           $lane_name = $irods_file_metadata->{run} . '_' . $irods_file_metadata->{well};
        }
	
        if(defined($irods_file_metadata->{library_id}) && ! defined($irods_file_metadata->{library_name}) )
        {
           $irods_file_metadata->{library_name} = $irods_file_metadata->{library_id}; 
        }
	
        if(defined($irods_file_metadata->{sample}) && ! defined($irods_file_metadata->{sample_public_name}) )
        {
           $irods_file_metadata->{sample_public_name} = $irods_file_metadata->{sample}; 
        }
	
	next unless(defined($irods_file_metadata->{study_name}));
	next unless(defined($irods_file_metadata->{sample_common_name}));
	next unless(defined($irods_file_metadata->{md5}));
	
        eval {
	      $file_metadata = UpdatePipeline::PB::FileMetaData->new(
	            study_name              => $irods_file_metadata->{study_name},
	            study_accession_number  => $irods_file_metadata->{study_accession_number},
	            library_name            => $irods_file_metadata->{library_name},
	            library_ssid            => $irods_file_metadata->{library_id},
	            sample_name             => $irods_file_metadata->{sample},
	            sample_accession_number => $irods_file_metadata->{sample_accession_number},
	            sample_common_name      => $irods_file_metadata->{sample_common_name},
	            supplier_name           => $irods_file_metadata->{sample_public_name},
	            study_ssid              => $irods_file_metadata->{study_id},
	            sample_ssid             => $irods_file_metadata->{sample_id},
	            lane_name               => $lane_name,
	            ebi_run_acc             => $irods_file_metadata->{ebi_run_acc},
	            md5                     => $irods_file_metadata->{md5},
		    # need full location here
	            file_location           => $irods_file_metadata->{file_location}
	        );
        };
        if ($@) {
            # An error occured while trying to get data from IRODs, usually a transient error which will probably be fixed next time its run
            next;
        }
		
        # fill in the blanks with data from the ML warehouse
        MLWarehouse::FileMetaDataPopulation->new( file_meta_data => $file_metadata, _dbh => $self->ml_warehouse_dbh )->populate();

        push( @files_metadata, $file_metadata );
    }

    return \@files_metadata;
}

sub _get_irods_file_metadata_for_studies {
    my ($self) = @_;
    my @files_metadata;
    my @unsorted_file_locations;
    my @sorted_file_locations;

    for my $irods_study ( @{ $self->_irods_studies } ) {
        for my $file_metadata ( @{ $irods_study->file_locations() } ) {
            push( @unsorted_file_locations, $file_metadata );
        }
    }
    $self->_limit_returned_results( \@unsorted_file_locations );
    for my $file_location ( @unsorted_file_locations ) {
        print "Syncing file: $file_location\n" if($self->verbose_output);
        push( @files_metadata, IRODS::File->new( file_location => $file_location )->file_attributes );
    }

    return \@files_metadata;
}


__PACKAGE__->meta->make_immutable;
no Moose;
1;
