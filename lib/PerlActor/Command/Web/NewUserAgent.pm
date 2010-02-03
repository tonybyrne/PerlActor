package PerlActor::Command::Web::NewUserAgent;

use strict;

use base 'PerlActor::Command::Web';

use WWW::Mechanize;

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	$self->newUserAgent();
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
