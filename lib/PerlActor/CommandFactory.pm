package PerlActor::CommandFactory;

use strict;

use base 'PerlActor::Object';

my @STANDARD_NAMESPACES = qw(PerlActor::Command PerlActor::Command::Web);

#===============================================================================================
# Public Methods
#===============================================================================================

sub create
{
	my ($self, $commandName, @commandArgs) = @_;

	return $self->create('Null')
		unless $commandName;

	my $error = '';
	
	my @classesToTry = map { $_ . '::' . $commandName } $self->getNameSpaces();
	push @classesToTry, $commandName;

	foreach my $class (@classesToTry)
	{
		my $error = $self->_compile($class);
		return $class->new(@commandArgs) unless $error;
	}
	
	return $self->create('Unknown', $error);

}

sub getNameSpaces
{
	return @STANDARD_NAMESPACES;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

sub _compile
{
	my ($self, $class) = @_;
	return if (eval "require $class");
	return $@;
}

# Keep Perl happy.
1;
