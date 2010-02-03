package PerlActor::test::WebCommandTest;

use base 'PerlActor::test::TestCase';
use strict;
use Error qw( :try );
use PerlActor::Command::Web::NewUserAgent;
use PerlActor::Command::Web::GoTo;
use PerlActor::Script;

#===============================================================================================
# Public Methods
#===============================================================================================

sub test_new_user_agent
{
	my $self = shift;
	my $command = new PerlActor::Command::Web::NewUserAgent();
	$command->execute();
	#$self->assert($command->hasValidUserAgent());
}

sub test_simple
{
	my $self = shift;
	my $command = new PerlActor::Command::Web::GoTo('http://www.google.com/');
	$command->newUserAgent();
	$command->execute();

	$self->assert_equals(200, $command->getStatus());
	$self->assert(qr/Google/, $command->getTitle());

	$command->setField( 'q' => 'Test' );
	$command->submit();

	$self->assert_equals(200, $command->getStatus());
	$self->assert(qr/Google/, $command->getTitle());
	$self->assert(qr/Test/,   $command->getTitle());	
}

sub test_uninitialised_user_agent_throws_exception
{
	my $self = shift;
	my $command = new PerlActor::Command::Web::GoTo('http://www.google.com/');

	my $exception;
	try
	{
		$command->execute();
	}
	catch PerlActor::Exception with
	{
		$exception = shift;
	};
	$self->assert($exception);
	$self->assert(qr/User Agent has not been initialised. Call 'NewUserAgent' command first!/,
		$exception);
	
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

#===============================================================================================
# Self Shunt Methods
#===============================================================================================

sub scriptStarted
{
	my $self = shift;
	$self->{scriptStartedCalled} = 1;
}

sub scriptEnded
{
	my $self = shift;
	$self->{scriptEndedCalled} = 1;
}

sub scriptAborted
{
	my $self = shift;
	$self->{scriptAbortedCalled} = 1;
}

sub scriptPassed
{
	my $self = shift;
	$self->{scriptPassedCalled} = 1;
}

sub scriptFailed
{
	my $self = shift;
	$self->{scriptFailedCalled} = 1;
}

sub commandStarted
{
	my $self = shift;
	$self->{commandsStarted}++;
}

sub commandEnded
{
	my $self = shift;
	$self->{commandsEnded}++;
}

sub commandAborted
{
	my $self = shift;
	$self->{commandsAborted}++;
}

sub commandPassed
{
	my $self = shift;
	$self->{commandsPassed}++;
}

sub commandFailed
{
	my $self = shift;
	$self->{commandsFailed}++;
}


# Keep Perl happy.
1;
