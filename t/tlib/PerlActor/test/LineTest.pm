package PerlActor::test::LineTest;

use base 'PerlActor::test::TestCase';
use strict;
use Error qw( :try );
use PerlActor::Line;

#===============================================================================================
# Public Methods
#===============================================================================================

sub set_up
{
	my $self = shift;
	$self->{line} = new PerlActor::Line();
}

sub test_substitutePlaceHolders_multi_token_line_with_placeholders
{
	my $self = shift;
	my $line = $self->{line}->substitutePlaceHolders('test $0 $1 $2 "$0 again"','one','two','three');
	$self->assert_str_equals('test one two three "one again"', $line);
}

sub test_substitutePlaceHolders_multi_placeholders_per_token
{
	my $self = shift;
	my $line = $self->{line}->substitutePlaceHolders('test "$0 $1 $2"','one','two','three');
	$self->assert_str_equals('test "one two three"', $line);
}

sub test_substitutePlaceHolders_escaped_placeholders
{
	my $self = shift;
	my $line = $self->{line}->substitutePlaceHolders('test $$0 $0','one');
	$self->assert_str_equals('test $0 one', $line);
}

sub test_substitutePlaceHolders_too_few_placeholders_throws_exception
{
	my $self = shift;
	my $caughtException;
	try
	{
		my $line = $self->{line}->substitutePlaceHolders('test $0', ());
	}
	otherwise
	{
		$caughtException = 1;
	};
	$self->assert($caughtException);
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
