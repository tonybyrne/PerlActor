package PerlActor::NullListener;

use base 'PerlActor::Object';

use strict;

use PerlActor::Script;

#===============================================================================================
# Public Methods
#===============================================================================================

sub scriptStarted
{
}

sub scriptEnded
{
}

sub scriptAborted
{
}

sub scriptPassed
{
}

sub scriptFailed
{
}

sub commandStarted
{
}

sub commandEnded
{
}

sub commandAborted
{
}

sub commandPassed
{
}

sub commandFailed
{
}

#===============================================================================================
# Protected Methods - Don't even think about calling these from outside the class.
#===============================================================================================

# Keep Perl happy.
1;
