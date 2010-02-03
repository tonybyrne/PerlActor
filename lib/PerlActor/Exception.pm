package PerlActor::Exception;

use strict;

use Error qw( :try );

use base qw (Error::Simple);

# Keep Perl happy.
1;
