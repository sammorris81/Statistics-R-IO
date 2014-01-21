#!perl -T
use 5.012;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 15;

use Statistics::R::REXP::Integer;

my $empty_vec = new_ok('Statistics::R::REXP::Integer', [  ], 'new integer vector' );

is($empty_vec, $empty_vec, 'self equality');

my $empty_vec_2 = Statistics::R::REXP::Integer->new();
is($empty_vec, $empty_vec_2, 'empty integer vector equality');

my $vec = Statistics::R::REXP::Integer->new(elements => [3, 4, 11]);
my $vec2 = Statistics::R::REXP::Integer->new(elements => [3, 4, 11]);
is($vec, $vec2, 'integer vector equality');

my $another_vec = Statistics::R::REXP::Integer->new(elements => [3, 4, 1]);
isnt($vec, $another_vec, 'integer vector inequality');

my $truncated_vec = Statistics::R::REXP::Integer->new(elements => [3.3, 4.0, 11]);
is($truncated_vec, $vec, 'constructing from floats');

is($empty_vec->to_s, 'integer()', 'empty integer vector text representation');
is($vec->to_s, 'integer(3, 4, 11)', 'integer vector text representation');

is_deeply($empty_vec->elements, [], 'empty integer vector contents');
is_deeply($vec->elements, [3, 4, 11], 'integer vector contents');
is($vec->elements->[2], 11, 'single element access');

is_deeply(Statistics::R::REXP::Integer->new(elements => [3.3, 4.0, '3x', 11])->elements,
          [3, 4, undef, 11], 'constructor with non-numeric values');

is_deeply(Statistics::R::REXP::Integer->new(elements => [3.3, 4.0, [7, [20.9, 44.1]], 11])->elements,
          [3, 4, 7, 21, 44, 11], 'constructor from nested arrays');

ok(! $empty_vec->is_null, 'is not null');
ok( $empty_vec->is_vector, 'is vector');
