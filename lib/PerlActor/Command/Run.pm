package PerlActor::Command::Run;

use strict;

use base 'PerlActor::Command';

use PerlActor::Exception;

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	$self->executeScript($self->getParams());
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
