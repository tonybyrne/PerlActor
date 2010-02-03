package PerlActor::test::NullCommandTest;

use base 'PerlActor::test::TestCase';
use strict;
use PerlActor::Command::Null;

#===============================================================================================
# Public Methods
#===============================================================================================

sub test_execute_implemented
{
	my $self = shift;
	my $command = new PerlActor::Command::Null();
	$command->execute();
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
