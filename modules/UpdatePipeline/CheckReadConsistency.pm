package UpdatePipeline::CheckReadConsistency;
use Moose;
use Pathogens::ConfigSettings;
use UpdatePipeline::Exceptions;
use IPC::Cmd qw(run);

=head1 NAME

UpdatePipeline::CheckReadConsistency   - Perform read number consistency check between a lane and its IRODS counterpart

=head1 SYNOPSIS

my $consistency_evaluator = UpdatePipeline::CheckReadConsistency->new( _vrtrack => $vrtrack );

if ( $consistency_evaluator->read_counts_are_consistent( {irods_read_count => 100000, lane_name => '1234_5#6'} ) {
    #the number of reads between IRODS and tracked files matched up
} 

=cut

#keep the attributes read only!
has '_vrtrack'         => ( is => 'ro', isa => 'VRTrack::VRTrack', required => 1 );
has 'environment'      => ( is => 'ro', isa => 'Str', default => 'production' );
has '_config_settings' => ( is => 'ro', isa => 'HashRef', lazy_build => 1 );
has '_fastq_root_path' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
has '_database_name'   => ( is => 'ro', isa => 'Str', lazy_build => 1 );



=head2 _config_settings

 Usage     : $self->_config_settings;
 Purpose   : reads the "config.yml" and returns a hashref to its contents.
 Returns   : a hashref.
 Argument  : none.
 Comment   : $self (class) must have 'environment' attribute ('test' or 'production').

=cut

sub _build__config_settings {
    my ($self) = @_;
    return \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}

=head2 _database_name

 Usage     : $self->_database_name;
 Purpose   : returns the name of the database that VRTrack::VRTrack has connected to.
 Returns   : a string (the name of the connected vrtrack database)
 Argument  : none

=cut

sub _build__database_name {
    return $_[0]->_vrtrack->{'_db_params'}->{'database'};
}

=head2 read_counts_are_consistent

 Usage     : $consistency_evaluator->read_counts_are_consistent( {lane_name => '1234_5#6', irods_read_count => 50} );
 Purpose   : checks if the read count for a lane is identical in iRODS and vrtrack file-system
 Returns   : returns 1 for true, 0 for false
 Argument  : an anonymous hash with values for two keys: "lane_name" (Str) and "irods_read_count" (Int)
 Comment   : The read count for the vr-track file-system is obtained by gunzip-ping the fastq.gz files
             and counting the tetrads (i.e. assuming four lines per read).

=cut

sub read_counts_are_consistent {
    my ($self, $args) = @_;

    my $path_to_directory = $self->_full_path_by_lane_name( $args->{'lane_name'} );
    my $fastq_file_names  = $self->_fastq_file_names_by_lane_name( $args->{'lane_name'} );
    my $lane_total;

    $lane_total = $self->_get_lane_read_count($path_to_directory, $fastq_file_names);

    if ($args->{'irods_read_count'} == $lane_total) {
        return 1;
    }
    else {
        return 0;
    }
}

=head2 _get_lane_read_count

 Usage     : $self->_get_lane_read_count( $lane_data_directory, $names_files);
 Purpose   : Sums up the total number of reads for the fastq files in a lane data directory on the VRTrack file-system.
 Returns   : An integer (total number of reads)
 Argument  : 1) (Str) path to the directory on the VRTrack file-system where gzipped fastq files (see the second argument) reside.
             2) (ArrayReference) names of the gzipped fastq files that are to be counted and summed up.

=cut

sub _get_lane_read_count {
    my ($self, $path_to_directory, $fastq_file_names) = @_;

    my $total_reads_in_lane=0;
    foreach my $file_name (@$fastq_file_names) {

        my $full_path_to_file = join( '/', ($path_to_directory, $file_name) );
        $total_reads_in_lane += $self->_count_line_tetrads_in_gzipped_fastq_file($full_path_to_file);

    }

    return $total_reads_in_lane;
}

=head2 _count_line_tetrads_in_gzipped_fastq_file

 Usage     : $self->_count_line_tetrads_in_gzipped_fastq_file( $path_to_gzipped_fastq_file );
 Purpose   : Counts the number of tetrads (groups of four lines) by gunzip-ping the fastq.gz file
 Returns   : An integer (number of line tetrads)
 Argument  : (Str) path to a gzipped fastq file on the VRTrack file-system
 Throws    : UpdatePipeline::Exceptions::CommandFailed, UpdatePipeline::Exceptions::FileNotFound
 Comment   : For gunzip and line count, two system processes are started in a shell pipeline.
             BASH, by default, returns the success message of the last process in the pipeline 
             even if earlier processes in the pipeline fail. To avoid this caveat, BASH offers 
             "set -o pipefail" option which enables failure messages if any of the processes in 
             a pipeline fail.

=cut

sub _count_line_tetrads_in_gzipped_fastq_file {
    my ($self, $file_name) = @_;

    if (not -e $file_name) {
        UpdatePipeline::Exceptions::FileNotFound->throw(error => "Error: Missing file:\n".$file_name);
    }

    my $command = "set -o pipefail; gunzip -c $file_name | wc -l";

    #IPC::Cmd's run() provides extensive details when running system commands.
    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) = run( command => $command );

    if ( $success ) {

        #The number of line tetrads equals the number of reads in a fastq.
        return $stdout_buf->[0]/4;

    } else {
        my $error_str = "The error occured when running:\n\t$command\n\t\t". join("\n", @$stderr_buf);
        UpdatePipeline::Exceptions::CommandFailed->throw( error => "Error: System exited with non-zero status: $command\n$error_str" );
    }
}

=head2 _full_path_by_lane_name

 Usage     : $self->_full_path_by_lane_name( $lane_name );
 Purpose   : Retrives the hierarchy path for a lane and appends it to the root path of the VRTrack file-system.
 Returns   : A string (root path of VRTrack file system with the appended hierarchy path for a lane).
 Argument  : (Str) a lane name, e.g. '1234_5#6'.

=cut

sub _full_path_by_lane_name {
    my ($self, $lane_name) = @_;
    my $hierarchical_name = $self->_vrtrack->hierarchy_path_of_lane_name($lane_name);   
    my $path = join('/', (  $self->_fastq_root_path
                          , $hierarchical_name
                         ) 
                   );
    
    return $path;
}

=head2 _fastq_root_path

 Usage     : $self->_fastq_root_path
 Purpose   : Retrieves the VRTrack file-system's root path where all the project data is mounted on
 Returns   : A string (root path to the VRTrack file-system)
 Argument  : none

=cut

sub _build__fastq_root_path {
    my ($self) = @_;

    my $dbname = $self->_database_name;
    my $config_settings = $self->_config_settings;
    my $root_path = $config_settings->{'root_path_by_db_name'}->{$dbname};
    
    return $root_path;
}

=head2 _fastq_file_names_by_lane_name

 Usage     : $self->_fastq_file_names_by_lane_name( $lane_name );
 Purpose   : Retrieves the names of (gzipped) fastq files that are associated with a lane name.
 Returns   : An ArrayReference (the references array contains the names of the gzipped fastq files).
 Argument  : (Str) a lane name, e.g. '1234_5#6'.
           
=cut

sub _fastq_file_names_by_lane_name {
    my ($self, $lane_name) = @_;

    my $lane = VRTrack::Lane->new_by_name( $self->_vrtrack, $lane_name );

    my $found_files = $lane->files; #how likely to go wrong?

    my @file_names;
    foreach my $vrtrack_file ( @{$found_files} ) {
        push @file_names, $vrtrack_file->name;
    }

    return \@file_names;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
