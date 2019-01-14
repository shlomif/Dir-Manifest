#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 5;
use Dir::Manifest ();

use Socket qw(:crlf);

use Path::Tiny qw/ path tempdir tempfile cwd /;

{
    my $dir = tempdir();

    my $fh = $dir->child("list.txt");
    my $d  = $dir->child("texts");
    $d->mkpath;

    $fh->spew_utf8("f%%g\n");

    my $obj;
    my @keys;
    eval {
        $obj = Dir::Manifest->new(
            {
                manifest_fn => "$fh",
                dir         => "$d",
            }
        );

        @keys = @{ $obj->get_keys };
    };

    # TEST
    like(
        $@,
        qr/invalid characters in key.*f%%g/i,
        "Throws an exception on invalid characters.",
    );
    $fh->spew_utf8(".hidden\n");

    eval {
        $obj = Dir::Manifest->new(
            {
                manifest_fn => "$fh",
                dir         => "$d",
            }
        );

        @keys = @{ $obj->get_keys };
    };

    # TEST
    like(
        $@,
        qr/Key does not start with an alphanumeric.*\.hidden/i,
        "Throws an exception on invalid characters.",
    );

    $fh->spew_utf8("trail_dots...\n");

    eval {
        $obj = Dir::Manifest->new(
            {
                manifest_fn => "$fh",
                dir         => "$d",
            }
        );

        @keys = @{ $obj->get_keys };
    };

    # TEST
    like(
        $@,
        qr/Key does not end with an alphanumeric.*trail_dots\.\.\./i,
        "Throws an exception on invalid characters.",
    );

    $fh->spew_utf8("one\ntwo\nthree\n");
    my $key;

    eval {
        $obj = Dir::Manifest->new(
            {
                manifest_fn => "$fh",
                dir         => "$d",
            }
        );

        @keys = @{ $obj->get_keys };

        $key = $obj->get_obj("not_exist");
    };

    # TEST
    like(
        $@,
        qr/No such key.*not_exist/i,
        "Throws an exception on invalid characters.",
    );

    # TEST
    is_deeply( \@keys, [qw/one three two/], "get_keys worked.", );
}
