#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 1;
use Dir::Manifest::Slurp qw/ as_lf /;

use Socket qw(:crlf);

{
    # TEST
    is( as_lf("hello\r\nworld"), "hello${LF}world", "as_lf #1" );
}
