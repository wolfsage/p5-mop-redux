use strict;
use warnings;
use Test::More;
use Test::Fatal;

use twigils;

{
    twigils::intro_twigil_var('$!foo');
    twigils::intro_twigil_var('$.bar');

    $!=123;
    is 0+$!, 123;
    $.=123;
    is$., 123;

    $!foo = 1;
    $.bar = 2;

    is $!foo, 1;
    is $.bar, 2;

    is "$!foo$.bar", 12;
}

{
    eval 'warn $!foo';
    like $@, qr/^twigil variable \$!foo not found/;

    eval 'twigils::intro_twigil_var($foo)';
    like $@, qr/^Unable to extract compile time constant twigil variable name/;

    like exception {
        &twigils::intro_twigil_var('foo');
    }, qr/called as a function/;
}

{
    $! = 123;
    ok 0+$! eq 123;
    $. = 123;
    ok $. eq 123;
}

done_testing;
