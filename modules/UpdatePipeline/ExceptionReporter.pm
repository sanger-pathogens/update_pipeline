=head1 NAME

ExceptionReporter.pm   - Consume all exceptions, group them sensibly and output a nice report

=head1 SYNOPSIS

use UpdatePipeline::ExceptionReporter;
my $exception_reporter = UpdatePipeline::ExceptionReporter->new();

$exception_reporter->add_exception($exception);
$exception_reporter->add_exception($exception);
....

$exception_reporter->print_report();

=cut

package UpdatePipeline::ExceptionReporter;
use Moose;
use UpdatePipeline::Exceptions;
use Data::Dumper;


has '_exceptions'               => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });
has '_unknown_common_names'     => ( is => 'ro', isa => 'HashRef',  default => sub { {} });
has '_undefined_common_names'   => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });
has '_inconsistent_total_reads' => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });
has '_bad_irods_records'        => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });
has '_path_changed_to_lanes'    => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });
has '_unclassified_exceptions'  => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });

has 'print_unclassified'        => ( is => 'rw', isa => 'Bool', default => 1);

sub add_exception
{
  my($self, $exception) = @_;  
  #print Dumper $exception;
  push(@{$self->_exceptions},$exception);
}

sub print_report
{
  my($self,$print_unclassified) = @_;
  $self->print_unclassified($print_unclassified);
  
  $self->_build_report;
  
  for my $common_name (sort keys %{$self->_unknown_common_names})
  {
    print "Unknown common name\t$common_name\n";
  }
  for my $sample_name (sort @{$self->_undefined_common_names})
  {
    print "Undefined common name\t$sample_name\n";
  }
  for my $filename (sort @{$self->_inconsistent_total_reads})
  {
     print "Inconsistent total reads\t$filename\n";
  }
  for my $error_description (sort @{$self->_bad_irods_records})
  {
    print "Irods data missing: $error_description\n";
  }
  for my $filename (sort @{$self->_path_changed_to_lanes})
  {
    print "Lanes reimported\t$filename\n";
  }
  
  if(@{$self->_unclassified_exceptions} > 0)
  {
    print "Unclassified exceptions\t".@{$self->_unclassified_exceptions}."\n";
    for my $unclassified_exception (sort @{$self->_unclassified_exceptions})
    {
      print "$unclassified_exception\n";
    }
  }

}

sub _build_report
{
   my($self) = @_;
   for my $exception (@{$self->_exceptions})
   {
     if($exception->isa("UpdatePipeline::Exceptions::UnknownCommonName"))
     {
       $self->_unknown_common_name($exception);
     }
     elsif($exception->isa("UpdatePipeline::Exceptions::UndefinedSampleCommonName"))
     {
       $self->_undefined_common_name($exception);
     }
     elsif($exception->isa("UpdatePipeline::Exceptions::TotalReadsMismatch"))
     {
       $self->_total_read_inconsistency($exception);
     }
     elsif($exception->isa("UpdatePipeline::Exceptions::UndefinedSampleName") || 
           $exception->isa("UpdatePipeline::Exceptions::UndefinedStudySSID")  ||
           $exception->isa("UpdatePipeline::Exceptions::UndefinedLibraryName"))
     {
       $self->_bad_irods_record($exception);
     }
     elsif($exception->isa("UpdatePipeline::Exceptions::PathToLaneChanged"))
     {
       $self->_path_changed_to_lane($exception);
     }
     else
     {
       # dont do anything with these exceptions other than count them
       $self->_unclassified_exception($exception);
     }
   }
   1;
}

sub _unclassified_exception
{
  my($self,$exception) = @_;
  push(@{$self->_unclassified_exceptions}, $exception->error);
}

sub _path_changed_to_lane
{
  my($self,$exception) = @_;
  push(@{$self->_path_changed_to_lanes}, $exception->error);
}

sub _undefined_common_name
{
  my($self,$exception) = @_;
  push(@{$self->_undefined_common_names}, $exception->error);
}

sub _bad_irods_record
{
   my($self,$exception) = @_;
   my $error_message = $exception->description.' '.$exception->error;
   push(@{$self->_bad_irods_records}, $error_message);
}

sub _total_read_inconsistency
{
  my($self,$exception) = @_;
  push(@{$self->_inconsistent_total_reads}, $exception->error);
}

sub _unknown_common_name
{
  my($self,$exception) = @_;
  $self->_unknown_common_names->{$exception->error}++;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;
