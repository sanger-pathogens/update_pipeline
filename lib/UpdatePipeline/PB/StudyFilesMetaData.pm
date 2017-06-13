package UpdatePipeline::PB::StudyFilesMetaData;

# ABSTRACT: Take in the name of a study and produce a metadata object for each experiment file

=head1 SYNOPSIS

Take in the name of a study and produce a metadata object for each experiment file. Lookup the warehouse, look for files in irods, look for metadata on each file.
   use UpdatePipeline::PB::StudyFilesMetaData;

   my $obj = UpdatePipeline::PB::StudyFilesMetaData->new(
       study_name        => 'ABC',
       dbh               => $dbh
     );
   $obj->files_metadata();

=cut

use Moose;
use Scalar::Util qw(looks_like_number);
use UpdatePipeline::PB::FileMetaData;

extends 'IRODS::UpdatePipeline::IRODS';

has 'files_metadata'  => ( is => 'ro', isa      => 'ArrayRef', lazy => 1, builder => '_build_files_metadata' );
has 'file_type'       => ( is => 'ro', default  => 'h5', isa => 'Str' );

sub _build_files_metadata {
    my ($self) = @_;
    my @files_metadata;

    my @irods_files_metadata = @{ $self->_get_irods_file_metadata_for_studies() };

    for my $irods_file_metadata (@irods_files_metadata) {
        my $file_metadata;
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
	            file_location           => $irods_file_metadata->{file_name}
	        );
        };
        if ($@) {
            # An error occured while trying to get data from IRODs, usually a transient error which will probably be fixed next time its run
            next;
        }
		
        # fill in the blanks with data from the ML warehouse
        MLWarehouse::FileMetaDataPopulation->new( file_meta_data => $file_metadata, _dbh => $self->_ml_warehouse_dbh )->populate();

        push( @files_metadata, $file_metadata );
    }

    my @sorted_files_metadata = reverse( ( sort ( sort_by_file_name @files_metadata ) ) );

    return \@sorted_files_metadata;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
