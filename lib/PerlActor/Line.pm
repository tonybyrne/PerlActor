package PerlActor::Line;
use strict;
use base 'PerlActor::Object';
use fields qw(  );

use PerlActor::Exception::PlaceholderNotDefined;

#===============================================================================================
# Public Methods
#===============================================================================================

sub substitutePlaceHolders
{
	my ($self, $line, @placeholders) = @_;

	while ($line =~ /(?<!\$)\$([0-9])/)
	{
		my $index = $1;
		my $value = $placeholders[$index];
		throw PerlActor::Exception::PlaceholderNotDefined("No value provided for placeholder \$$index in '$line'")
			unless $value;
		$line =~ s/(?<!\$)\$$index/$value/;
	}
	$line =~ s/\${2}/\$/g;
	return $line;
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================


# Keep Perl happy.
1;
