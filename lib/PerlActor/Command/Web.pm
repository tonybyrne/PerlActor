package PerlActor::Command::Web;

use strict;

use base 'PerlActor::Command';

use PerlActor::Exception;

use WWW::Mechanize;

#===============================================================================================
# Public Methods
#===============================================================================================

sub execute
{
	my $self = shift;
	
	#TODO Decide whether it is better to auto-vivify a user agent or throw and exception when no user agent is found.
	
	throw PerlActor::Exception("User Agent has not been initialised. Call 'NewUserAgent' command first!")
		unless $self->hasValidUserAgent();
		
	#$self->newUserAgent() unless $self->hasValidUserAgent();
}

sub newUserAgent
{
	my $self = shift;
	$self->{context}->{userAgent} = new WWW::Mechanize( agent => "PerlActor" );
}

sub getUserAgent
{
	my $self = shift;
	return $self->{context}->{userAgent};
}

sub hasValidUserAgent
{
	my $self = shift;
	my $userAgent = $self->getUserAgent();
	return $self->isOfType('WWW::Mechanize', $userAgent);
}

sub getStatus
{
	my $self = shift;
	return $self->getUserAgent()->status();
}

sub getTitle
{
	my $self = shift;
	return $self->getUserAgent()->title();
}

sub setField
{
	my ($self, $field, $value) = @_;
	$self->getUserAgent()->field( $field => $value );
}

sub submit
{
	my $self = shift;
	$self->getUserAgent()->submit();
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
