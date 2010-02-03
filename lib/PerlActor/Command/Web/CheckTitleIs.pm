package PerlActor::Command::Web::CheckTitleIs;

use strict;

use base 'PerlActor::Command::Web';

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	my $wantedTitle = $self->getParam(0);
	my $actualTitle = $self->getTitle();
	$self->assert($wantedTitle eq $actualTitle, "Expected page title '$wantedTitle', but got '$actualTitle'");
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
