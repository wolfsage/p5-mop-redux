#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use mop;

eval '
class Foo {
    has $!foo bar;
}
';
like($@, qr/^Couldn't parse attribute \$!foo/);

eval '
class Bar:Bar { }
';
like($@, qr/^Invalid identifier: Bar:Bar/);

TODO: {
    local $TODO = "Need to fix error handling on parser errors";
    my $capture;
    local $SIG{__WARN__} = sub { $capture .= "@_" };

    eval '
        class Bar { method foo {}, }
    ';

    undef $SIG{__WARN__};

    # Probably replace these with a strict check for actual error once it's decided
    # what that error should be 
    unlike($@, qr/Undefined subroutine called/, 'Parser error doesn\'t do weird things');
    unlike($capture, qr/Attempt to free unreferenced scalar/, 'Parser error doesn\'t do weird things');
}

done_testing;
