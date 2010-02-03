package PerlActor::test::ObjectTest;

use base 'PerlActor::test::TestCase';
use strict;
use PerlActor::Object;

#===============================================================================================
# Public Methods
#===============================================================================================

sub test_trim
{
	my $self = shift;
	$self->assert_str_equals("test", PerlActor::Object->trim("   test   "));
}

sub test_isOfType
{
	my $self = shift;
	$self->assert(! PerlActor::Object->isOfType( 'PerlActor::Object', 'a string'              ));
	$self->assert(! PerlActor::Object->isOfType( 'PerlActor::Object', 1234                    ));
	$self->assert(! PerlActor::Object->isOfType( 'PerlActor::Object', []                      ));
	$self->assert(! PerlActor::Object->isOfType( 'PerlActor::Object', {}                      ));

	$self->assert(  PerlActor::Object->isOfType( 'PerlActor::Object', new PerlActor::Object() ));
}


#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
