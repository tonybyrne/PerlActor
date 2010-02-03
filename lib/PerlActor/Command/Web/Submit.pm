package PerlActor::Command::Web::Submit;

use strict;

use base 'PerlActor::Command::Web';

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	$self->submit();
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
