package PerlActor::Object;

use fields qw( listener context );

use strict;

use Error qw(:try);

#===============================================================================================
# Public Methods
#===============================================================================================

sub new
{
	my $class = shift;
	my $self = fields::new($class);
	return $self;
}

sub setListener
{
	my $self = shift;
	$self->{listener} = shift;
}

sub getListener
{
	my $self = shift;
	return $self->{listener};
}

sub setContext
{
	my $self = shift;
	$self->{context} = shift;
}

sub getContext
{
	my $self = shift;
	return $self->{context};
}

sub trim
{
	my ($self, $string) = @_;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}

sub isOfType
{
	my ($self, $type, $thing) = @_;
	
	return unless ($thing and ref $thing);
	
	my $exception;
	my $isOfType;
	try
	{
		$isOfType = $thing->isa($type);
	}
	otherwise
	{
		$exception = shift;
	};
	
	return if $exception;
	return $isOfType;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
