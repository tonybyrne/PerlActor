package PerlActor::test::NullListenerTest;

use base 'PerlActor::test::TestCase';
use strict;
use PerlActor::NullListener;
#===============================================================================================
# Public Methods
#===============================================================================================

sub test_all_methods_exist
{
	my $self = shift;
	my $nl = new PerlActor::NullListener();

	$nl->scriptStarted();
	$nl->scriptEnded();	
	$nl->scriptAborted();	
	$nl->scriptPassed();
	$nl->scriptFailed();	

	$nl->commandStarted();
	$nl->commandEnded();
	$nl->commandAborted();
	$nl->commandPassed();
	$nl->commandFailed();
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
