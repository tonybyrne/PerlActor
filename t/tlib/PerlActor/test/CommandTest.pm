package PerlActor::test::CommandTest;

use base 'PerlActor::test::TestCase';
use strict;
use Error qw( :try );
use PerlActor::Command::Dummy;
use PerlActor::Command::Broken;
use PerlActor::Command::Unknown;
use PerlActor::Exception;
use PerlActor::Exception::NotImplemented;
use PerlActor::Exception::CommandNotFound;

#===============================================================================================
# Public Methods
#===============================================================================================

sub test_getParam
{
	my $self = shift;
	my $command = new PerlActor::Command::Dummy(1,'two',3);
	$self->assert_equals(1, $command->getParam(0));
	$self->assert_str_equals('two', $command->getParam(1));
	$self->assert_equals(3, $command->getParam(2));
	$self->assert_null($command->getParam(3));	
}

sub test_getParams
{
	my $self = shift;
	my $command = new PerlActor::Command::Dummy(1,'two',3);
	my @params = $command->getParams();
        $self->assert_equals(1, $params[0]);
        $self->assert_str_equals('two', $params[1]);
        $self->assert_equals(3, $params[2]);
        $self->assert_null($params[3]);

}

sub test_unimplemented_execute_throws_exception
{
	my $self = shift;
	my $command = new PerlActor::Command::Broken();
	my $exception;
	try
	{
		$command->execute();
	}
	catch PerlActor::Exception::NotImplemented with
	{
		$exception = shift;
	};
	$self->assert($exception);
}

sub test_execute_on_unknown_command_throws_exception
{
	my $self = shift;
	my $command = new PerlActor::Command::Unknown(1,2,3);
	my $exception;
	try
	{
		$command->execute();
	}
	catch PerlActor::Exception::CommandNotFound with
	{
		$exception = shift;
	};
	$self->assert($exception);
	$self->assert(qr/unknown or invalid command/, $exception);
}

sub test_executeScript_with_test_script
{
	my $self = shift;
	my $command = new PerlActor::Command();
	$command->setListener($self);
	$command->executeScript("t/scripts/do_nothing.pact");
	$self->assert($self->{scriptStartedCalled});
	$self->assert($self->{scriptEndedCalled});
	$self->assert($self->{scriptPassedCalled});
}

sub test_executeScript_with_non_existing_file_throws_exception
{
	my $self = shift;
	my $command = new PerlActor::Command();
	my $scriptName = "t/scripts/does_not_exist.pact";
	my $exception;
	try
	{
		$command->executeScript($scriptName);
	}
	catch PerlActor::Exception with
	{
		$exception = shift;
	};
	$self->assert($exception);
	$self->assert(qr/cannot open test script file '$scriptName'/, $exception);

}

sub test_assert
{
	my $self = shift;
	my $command = new PerlActor::Command::Dummy();

	$self->assert_exception( 'PerlActor::Exception::AssertionFailure', sub { $command->assert(0, 'failed') });
	$self->assert_no_exception(sub { $command->assert(1, 'passed') });
}

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

sub scriptPassed
{
	my $self = shift;
	$self->{scriptPassedCalled} = 1;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
