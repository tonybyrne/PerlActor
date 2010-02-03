package PerlActor::Command::Web::GoTo;

use strict;

use base 'PerlActor::Command::Web';

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	$self->SUPER::execute();
	my $uri = $self->getParam(0);
	$self->getUserAgent()->get($uri);
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
