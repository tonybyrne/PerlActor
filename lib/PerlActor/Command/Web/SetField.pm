package PerlActor::Command::Web::SetField;

use strict;

use base 'PerlActor::Command::Web';

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	my $field = $self->getParam(0);
	my $value = $self->getParam(1);
	$self->setField( $field => $value );
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
