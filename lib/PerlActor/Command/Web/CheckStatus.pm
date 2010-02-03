package PerlActor::Command::Web::CheckStatus;

use strict;

use base 'PerlActor::Command::Web';

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	my $wantedStatus = $self->getParam(0);
	my $actualStatus = $self->getStatus();
	$self->assert($wantedStatus == $actualStatus, "Expected status code '$wantedStatus', but got '$actualStatus'");
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
