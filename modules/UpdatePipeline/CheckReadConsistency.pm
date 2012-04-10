package UpdatePipeline::CheckReadConsistency;
use Moose;
use Pathogens::ConfigSettings;
use UpdatePipeline::Exceptions;
use IPC::Cmd qw(run);

=head1 NAME

CheckReadConsistency   - Perform read number consistency check between a lane and its IRODS counterpart

=head1 SYNOPSIS

my $consistency_evaluator = CheckReadConsistency->new( _vrtrack => $vrtrack );

if ( $consistency_evaluator->read_counts_are_consistent( {irods_read_count => 100000, lane_name => '1234_5#6'} ) {

    #the number of reads between IRODS and tracked files matched up
    
} 
else {

   #discrepancy

}

=cut


#keep the attributes read ONLY!!
has '_vrtrack'         => ( is => 'ro', isa => 'VRTrack::VRTrack', required => 1 );
has 'environment'      => ( is => 'ro', isa => 'Str', default => 'production' );
has '_config_settings' => ( is => 'ro', isa => 'HashRef', lazy_build => 1 );
has '_fastq_root_path' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
has '_database_name'   => ( is => 'ro', isa => 'Str', lazy_build => 1 );

sub _build__config_settings {
    my ($self) = @_;
    return \%{Pathogens::ConfigSettings->new(environment => $self->environment, filename => 'config.yml')->settings()};
}

sub _build__database_name {
    return $_[0]->_vrtrack->{'_db_params'}->{'database'};
}

sub read_counts_are_consistent {
    my ($self, $args) = @_;

    my $path_to_directory = $self->_full_path_by_lane_name( $args->{'lane_name'} );
    my $fastq_file_names  = $self->_fastq_file_names_by_lane_name( $args->{'lane_name'} );

    my $lane_total = $self->_get_lane_read_count($path_to_directory, $fastq_file_names);

    if ($args->{'irods_read_count'} == $lane_total) {
        return 1;
    }
    else {
        return 0;
    }
}

sub _get_lane_read_count {
    my ($self, $path_to_directory, $fastq_file_names) = @_;

    my $total_reads_in_lane=0;
    foreach my $file_name (@$fastq_file_names) {

        my $full_path_to_file = join( '/', ($path_to_directory, $file_name) );
        $total_reads_in_lane += $self->_count_line_tetrads_in_gzipped_fastq_file($full_path_to_file);

    }

    return $total_reads_in_lane;
}

sub _count_line_tetrads_in_gzipped_fastq_file {
    my ($self, $file_name) = @_;

    #"set -o pipefail" makes bash return a failure signal 
    #if any of the processes in the pipeline fails
    my $command = "set -o pipefail; gunzip -c $file_name | wc -l";

    #IPC::Cmd's "run" provides extensive details when running system commands
    my ( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) = run( command => $command );

    if ( $success ) {
        return $stdout_buf->[0]/4; #number of tetrads
    } else {
        my $error_str = "An error occured when running the command:\n\t$command\n\t\t". join("\n", @$stderr_buf);
        UpdatePipeline::Exceptions::CommandFailed->throw( error => "Error running $command:\n$error_str" );
    }

}

sub _build__fastq_root_path {
    my ($self) = @_;

    my $dbname = $self->_database_name;
    my $config_settings = $self->_config_settings;
    my $root_path = $config_settings->{'root_path_by_db_name'}->{$dbname};
    
    return $root_path;
}

sub _full_path_by_lane_name {
    my ($self, $lane_name) = @_;
    my $hierarchical_name = $self->_vrtrack->hierarchy_path_of_lane_name($lane_name);
    my $path = join('/', (  $self->_fastq_root_path
                          , $hierarchical_name
                         ) 
                   );
    
    return $path;
}

sub _fastq_file_names_by_lane_name {
    my ($self, $lane_name) = @_;
    my $lane = VRTrack::Lane->new_by_name( $self->_vrtrack, $lane_name );

    #arr. ref. to VRTrack::File objects.
    #throw exception if $lane->files returns undef ???  <------------------------------!!!
    my @file_names;
    foreach my $vrtrack_file_obj ( @{$lane->files} ) {
        push @file_names, $vrtrack_file_obj->name;
    }

    return \@file_names;
}


1;
