package PerlActor::Command;

use strict;

use base 'PerlActor::Object';
use fields qw( params );

use Error;

use PerlActor::Script;
use PerlActor::Exception::AssertionFailure;
use PerlActor::Exception::NotImplemented;

#===============================================================================================
# Public Methods
#===============================================================================================

sub new
{
	my $proto = shift;
	my @params = @_;
	my $self = $proto->SUPER::new(@_);
	$self->{params} = \@params;
	return $self;
}

sub getParam
{
	my $self = shift;
	my $paramNumber = shift;
	return $self->{params}->[$paramNumber];
}

sub getParams
{
	my $self = shift;
	return @{$self->{params}};
}

sub execute
{
	my $self = shift;
	my $class = ref $self;
	throw PerlActor::Exception::NotImplemented("command class '$class' does not implement execute()");
}

sub executeScript
{
	my ($self, $file, @placeholderValues) = @_;
	
	open SCRIPT, "$file"
		or throw PerlActor::Exception("cannot open test script file '$file': $!\n");
			
	my @lines = <SCRIPT>;
	my $script = new PerlActor::Script("$file");
	$script->setListener($self->getListener());
	$script->setLines(@lines);
	$script->setPlaceholderValues(@placeholderValues);
	$script->execute();
	close SCRIPT;
}

sub assert
{
	my ($self, $condition, $message) = @_;
	throw PerlActor::Exception::AssertionFailure($message)
		unless $condition;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
