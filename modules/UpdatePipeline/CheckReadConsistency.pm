package UpdatePipeline::CheckReadConsistency;
use Moose;

=head1 NAME

CheckReadConsistency   - Perform read number consistency check between a lane and its IRODS counterpart

=head1 SYNOPSIS

my $consistency_evaluator = CheckReadConsistency->new( _vrtrack => $vrtrack );

if ( $consistency_evaluator->read_counts_are_consistent( irods_read_count => 100000, lane_name => '1234_5#6' ) {
   #the number of reads between IRODS and tracked files matched up
} 
else {
   #there is some some discrepancy
}

=cut

use Pathogens::ConfigSettings;
use UpdatePipeline::Exceptions;

#the database should be read-only, as other attributes are set according to the
#initial choice of the database during the construction
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
    } else {
        return undef;
    }
}

sub _get_lane_read_count {
    my ($self, $path_to_directory, $fastq_file_names) = @_;

    my $total_reads_in_lane=0;
    foreach my $file_name (@$fastq_file_names) {
        my $full_path_to_file = join('/', (  $path_to_directory 
                                           , $file_name 
                                          )
                                    );
        $total_reads_in_lane += $self->_count_line_tetrads_in_gzipped_fastq_file($full_path_to_file);        
    }

    return $total_reads_in_lane;

}

sub _count_line_tetrads_in_gzipped_fastq_file {
    my ($self, $file_name) = @_;

    #prep the command
    my $cmd = qq[gunzip -c $file_name | echo \$((`wc -l`/4))];

    my $count = `$cmd`;

    if ( $? == -1 )
    {
        print "command failed: $!\n";
    }

    chomp $count;
    return $count;
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

    #ArrRef to VRTrack::File objects.
    #Throw error if $lane->files returns undef ???  <------------------------------!!!
    my @file_names;
    foreach my $vrtrack_file_obj ( @{$lane->files} ) {
        push @file_names, $vrtrack_file_obj->name;
    }

    return \@file_names;
}


1;
