use lib qw(
            ./lib 
            ./t/tlib
            ./examples/calculator/app
            ./examples/calculator/test
            ./examples/web/app
            ./examples/web/test
);
use strict;
use Test::Strict;
all_perl_files_ok();
