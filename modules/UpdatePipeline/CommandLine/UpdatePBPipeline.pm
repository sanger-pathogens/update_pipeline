package UpdatePipeline::CommandLine::UpdatePBPipeline;

# ABSTRACT: Update PB pipeline

=head1 SYNOPSIS

Update PB pipeline

=cut

use Moose;
use Getopt::Long qw(GetOptionsFromArray);
use VertRes::Utils::VRTrackFactory;
use UpdatePipeline::PB::UpdateAllMetaData;
use UpdatePipeline::Studies;

has 'args'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );
has 'help'        => ( is => 'rw', isa => 'Bool',     default  => 0 );
has '_error_message' => ( is => 'rw', isa => 'Str' );

has 'studyfile'                 => ( is => 'rw', isa => 'Str', );
has 'input_study_name'          => ( is => 'rw', isa => 'Str', );
has 'database'                  => ( is => 'rw', isa => 'Str', );
has 'number_of_files_to_return' => ( is => 'rw', isa => 'Int', default => 500 );
has 'parallel_processes'        => ( is => 'rw', isa => 'Int', default => 1 );
has 'verbose_output'            => ( is => 'rw', isa => 'Bool', default => 0 );
has 'errors_min_run_id'         => ( is => 'rw', isa => 'Int', default => 0 );
has 'update_if_changed'         => ( is => 'rw', isa => 'Bool', default => 0 );
has 'dont_use_warehouse'        => ( is => 'rw', isa => 'Bool', default => 0 );
has 'taxon_id'                  => ( is => 'rw', isa => 'Int', default => 0 );
has 'species_name'              => ( is => 'rw', isa => 'Str', );
has 'use_supplier_name'         => ( is => 'rw', isa => 'Bool', default => 0 );
has 'specific_run_id'           => ( is => 'rw', isa => 'Int', );
has 'specific_min_run'          => ( is => 'rw', isa => 'Int', default => 0 );
has 'no_pending_lanes'          => ( is => 'rw', isa => 'Bool', default => 1 );
has 'override_md5'              => ( is => 'rw', isa => 'Bool', default => 0 );
has 'withdraw_del'              => ( is => 'rw', isa => 'Bool', default => 0 );
has 'total_reads'               => ( is => 'rw', isa => 'Bool', default => 0 );
has 'lock_file'                 => ( is => 'rw', isa => 'Str', default => '.lock_file' );

sub BUILD {
    my ($self) = @_;
    my (
        $studyfile,             $help,              $number_of_files_to_return, $lock_file,
        $parallel_processes,    $verbose_output,    $errors_min_run_id,         $database,
        $input_study_name,      $update_if_changed, $dont_use_warehouse,        $taxon_id,
        $overwrite_common_name, $use_supplier_name, $specific_run_id,           $specific_min_run,
        $common_name_required,  $no_pending_lanes,  $species_name,              $override_md5,
        $withdraw_del,          $vrtrack_lanes,     $total_reads
    );

    GetOptionsFromArray(
        $self->args,
        's|studies=s'             => \$studyfile,
        'n|study_name=s'          => \$input_study_name,
        'd|database=s'            => \$database,
        'f|max_files_to_return=s' => \$number_of_files_to_return,
        'p|parallel_processes=s'  => \$parallel_processes,
        'v|verbose'               => \$verbose_output,
        'r|min_run_id=s'          => \$errors_min_run_id,
        'u|update_if_changed'     => \$update_if_changed,
        'w|dont_use_warehouse'    => \$dont_use_warehouse,
        'tax|taxon_id=i'          => \$taxon_id,
        'spe|species=s'           => \$species_name,
        'sup|use_supplier_name'   => \$use_supplier_name,
        'run|specific_run_id=i'   => \$specific_run_id,
        'min|specific_min_run=i'  => \$specific_min_run,
        'nop|no_pending_lanes'    => \$no_pending_lanes,
        'md5|override_md5'        => \$override_md5,
        'wdr|withdraw_del'        => \$withdraw_del,
        'trd|include_total_reads' => \$total_reads,
        'l|lock_file=s'           => \$lock_file,
        'h|help'                  => \$help,
    );

    $self->studyfile($studyfile)                                 if ( defined($studyfile) );
    $self->input_study_name($input_study_name)                   if ( defined($input_study_name) );
    $self->database($database)                                   if ( defined($database) );
    $self->number_of_files_to_return($number_of_files_to_return) if ( defined($number_of_files_to_return) );
    $self->parallel_processes($parallel_processes)               if ( defined($parallel_processes) );
    $self->verbose_output($verbose_output)                       if ( defined($verbose_output) );
    $self->errors_min_run_id($errors_min_run_id)                 if ( defined($errors_min_run_id) );
    $self->update_if_changed($update_if_changed)                 if ( defined($update_if_changed) );
    $self->dont_use_warehouse($dont_use_warehouse)               if ( defined($dont_use_warehouse) );
    $self->taxon_id($taxon_id)                                   if ( defined($taxon_id) );
    $self->species_name($species_name)                           if ( defined($species_name) );
    $self->use_supplier_name($use_supplier_name)                 if ( defined($use_supplier_name) );
    $self->specific_run_id($specific_run_id)                     if ( defined($specific_run_id) );
    $self->specific_min_run($specific_min_run)                   if ( defined($specific_min_run) );
    $self->no_pending_lanes($no_pending_lanes)                   if ( defined($no_pending_lanes) );
    $self->override_md5($override_md5)                           if ( defined($override_md5) );
    $self->withdraw_del($withdraw_del)                           if ( defined($withdraw_del) );
    $self->total_reads($total_reads)                             if ( defined($total_reads) );
    $self->lock_file($lock_file)                                 if ( defined($lock_file) );
    $self->help($help)                                           if ( defined($help) );

}

sub run {
    my ($self) = @_;

    ( !$self->help ) or die $self->usage_text;
    if ( defined( $self->_error_message ) ) {
        print $self->_error_message . "\n";
        die $self->usage_text;
    }
    my $study_names;
    if ( defined( $self->studyfile ) ) {
        $study_names = UpdatePipeline::Studies->new( filename => $self->studyfile )->study_names;
    }
    else {
        my @studyname = ( $self->input_study_name );
        $study_names = \@studyname;
    }

    my $vrtrack = VertRes::Utils::VRTrackFactory->instantiate( database => $self->database, mode => 'rw' );
    unless ($vrtrack) { die "Can't connect to tracking database:" . $self->database . " \n"; }

    if(defined($self->lock_file))
    {
      $self->create_lock($self->lock_file);
    }
    my $update_pipeline = UpdatePipeline::PB::UpdateAllMetaData->new(
        study_names               => $study_names,
        _vrtrack                  => $vrtrack,
        number_of_files_to_return => $self->number_of_files_to_return,
        verbose_output            => $self->verbose_output,
        minimum_run_id            => $self->errors_min_run_id,
        update_if_changed         => $self->update_if_changed,
        dont_use_warehouse        => $self->dont_use_warehouse,
        common_name_required      => $self->common_name_required,
        taxon_id                  => $self->taxon_id,
        species_name              => $self->species_name,
        use_supplier_name         => $self->use_supplier_name,
        specific_run_id           => $self->specific_run_id,
        specific_min_run          => $self->specific_min_run,
        no_pending_lanes          => $self->no_pending_lanes,
        override_md5              => $self->override_md5,
        vrtrack_lanes             => undef,
        add_raw_reads             => $self->total_reads,
    );
    $update_pipeline->update();
    
    
    if(defined($self->lock_file))
    {
      remove_lock($self->lock_file);
    }


}


# Taken from vr-codebase/scripts/run-pipeline
sub create_lock
{
    my ($self,$lock) = @_;
    if ( !$lock ) { return; } # the locking not requested

    if ( -e $lock )
    {
        # Find out the PID of the running pipeline
        my ($pid) = `cat $lock` || '';
        chomp($pid);
        if ( !($pid=~/^\d+$/) ) { print(qq[Broken lock file $lock? Expected number, found "$pid".\n]); }

        # Is it still running? (Will work only when both are running on the same host.)
        my ($running) = `ps h $pid`;
        if ( $running ) { die "Another process already running: $pid\n"; }
    }

    open(my $fh,'>',$lock) or die "Couldnt open lock file for writing";
    print $fh $$ . "\n";
    close($fh);

    return;
}

sub remove_lock
{
    my ($self,$lock) = @_;
    if ( $lock && -e $lock ) { unlink($lock); }
    return;
}


sub usage_text {
    my ($self) = @_;

    return <<USAGE;
    Usage: update_pb_pipeline [options]
    Update the metadata of PB samples from the warehouse and iRODS and insert it into a VRTracking database.
    
      -s|--studies                 <file of study names>
      -n|--study_name              <a single study name to update>
      -d|--database                <vrtrack database name>
      -f|--max_files_to_return     <optional limit on num of file to check per process>
      -p|--parallel_processes      <optional number of processes to run in parallel, defaults to 1>
      -v|--verbose                 <print out debugging information>
      -r|--min_run_id              <optionally filter out errors below this run_id, defaults to 6000>
      -u|--update_if_changed       <optionally delete lane & file entries, if metadata changes, for reimport>
      -w|--dont_use_warehouse      <dont use the warehouse to fill in missing data>
      -tax|--taxon_id              <optionally provide taxon id to overwrite species info in bam file common name>
      -spe|--species               <optionally provide the species name, which in combination with -tax avoids an NCBI lookup>
      -sup|--use_supplier_name     <optionally use the supplier name from the warehouse to populate name and hierarchy name of the individual table>
      -run|--specific_run_id       <optionally provide a specfic run id for a study>
      -min|--specific_min_run      <optionally provide a specfic minimum run id for a study to import>  
      -nop|--no_pending_lanes      <optionally filter out lanes whose npg QC status is pending>
      -md5|--override_md5          <optionally update md5 on imported file if the iRODS md5 changes>
      -wdr|--withdraw_del          <optionally withdraw a lane if has been deleted from iRODS>
      -trd|--include_total_reads   <optionally write the total_reads from bam metadata to the file table in vrtrack>  
      -l|--lock_file               <optional lock file to prevent multiple instances running>
      -h|--help                    <this message>

    # update all studies listed in the file in the given database
    update_pb_pipeline -s my_study_file -d pathogen_abc_track

    # update only the given study
    update_pb_pipeline -n "My Study" -d pathogen_abc_track

    # This help message
    update_pb_pipeline -h

USAGE
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
