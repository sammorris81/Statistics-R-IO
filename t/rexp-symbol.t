#!perl -T
use 5.012;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 8;

use Statistics::R::REXP::Symbol;

my $sym = new_ok('Statistics::R::REXP::Symbol', [ name => 'sym' ], 'new symbol' );

is($sym, $sym, 'self equality');

my $sym_2 = Statistics::R::REXP::Symbol->new(name => $sym);
is($sym, $sym_2, 'symbol equality with copy');
is(Statistics::R::REXP::Symbol->new($sym_2), $sym, 'copy constructor');
is(Statistics::R::REXP::Symbol->new('sym'), $sym, 'string constructor');

my $sym_foo = Statistics::R::REXP::Symbol->new(name => 'foo');
isnt($sym, $sym_foo, 'symbol inequality');

is($sym->name, 'sym', 'symbol name');

ok(! $sym->is_null, 'is not null');
