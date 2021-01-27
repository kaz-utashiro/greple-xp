use strict;
use warnings;
use utf8;
use Test::More;
use File::Spec;
use open IO => ':utf8';
use Text::ParseWords;

use lib '.';
use t::Util;

is(greple('-Mxp -c -i daemon t/passwd')->result, "25\n", "normal");
is(greple('-Mxp -c -i daemon t/passwd --exclude-file t/gcos.ptn')->result, "1\n", "--exclude t/gcos.ptn");
is(greple('-Mxp -c -i daemon t/passwd --exclude-file t/*.ptn')->result, "0\n", "--exclude t/*.ptn");
is(greple('-Mxp -c -i daemon t/passwd --exclude-file t/all.regex')->result, "0\n", "--exclude t/all.regex");
is(greple('-Mxp -c -i daemon t/passwd --include-file t/all.regex')->result, "25\n", "--include t/all.regex");

done_testing;
