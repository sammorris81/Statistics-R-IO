#!perl -T
use 5.010;
use strict;
use warnings FATAL => 'all';

use Test::More tests => 32;
use Test::Fatal;

use Statistics::R::REXP::Character;
use Statistics::R::REXP::List;

my $empty_vec = new_ok('Statistics::R::REXP::Character', [  ], 'new character vector' );

is($empty_vec, $empty_vec, 'self equality');

my $empty_vec_2 = Statistics::R::REXP::Character->new();
is($empty_vec, $empty_vec_2, 'empty character vector equality');

my $vec = Statistics::R::REXP::Character->new(elements => [3.3, '4.7', 'bar']);
my $vec2 = Statistics::R::REXP::Character->new([3.3, 4.7, 'bar']);
is($vec, $vec2, 'character vector equality');

is(Statistics::R::REXP::Character->new($vec2), $vec, 'copy constructor');
is(Statistics::R::REXP::Character->new(Statistics::R::REXP::List->new([3.3, [4.7, 'bar']])),
   $vec, 'copy constructor from a vector');

## error checking in constructor arguments
like(exception {
        Statistics::R::REXP::Character->new(sub {1+1})
     }, qr/Attribute \(elements\) does not pass the type constraint/,
     'error-check in single-arg constructor');
like(exception {
        Statistics::R::REXP::Character->new(1, 2, 3)
     }, qr/odd number of arguments/,
     'odd constructor arguments');
like(exception {
        Statistics::R::REXP::Character->new(elements => {foo => 1, bar => 2})
     }, qr/Attribute \(elements\) does not pass the type constraint/,
     'bad elements argument');

my $another_vec = Statistics::R::REXP::Character->new(elements => [3.3, '4.7', 'bar', undef]);
isnt($vec, $another_vec, 'character vector inequality');

my $na_heavy_vec = Statistics::R::REXP::Character->new(elements => ['foo', '', undef, 23]);
my $na_heavy_vec2 = Statistics::R::REXP::Character->new(elements => ['foo', 0, undef, 23]);
is($na_heavy_vec, $na_heavy_vec, 'NA-heavy vector equality');
isnt($na_heavy_vec, $na_heavy_vec2, 'NA-heavy vector inequality');

is($empty_vec .'', 'character()', 'empty character vector text representation');
is($vec .'', 'character(3.3, 4.7, bar)', 'character vector text representation');
is(Statistics::R::REXP::Character->new(elements => [undef]) .'',
   'character(undef)', 'text representation of a singleton NA');
is($na_heavy_vec .'', 'character(foo, , undef, 23)', 'empty characters representation');

is_deeply($empty_vec->elements, [], 'empty character vector contents');
is_deeply($vec->elements, [3.3, 4.7, 'bar'], 'character vector contents');
is($vec->elements->[1], 4.7, 'single element access');

is_deeply(Statistics::R::REXP::Character->new(elements => [3.3, 4.0, '3x', 11])->elements,
          [3.3, 4, '3x', 11], 'constructor with non-numeric values');

is_deeply(Statistics::R::REXP::Character->new(elements => [3.3, 4.0, [7, ['a', 'foo']], 11])->elements,
          [3.3, 4, 7, 'a', 'foo', 11], 'constructor from nested arrays');

ok(! $empty_vec->is_null, 'is not null');
ok( $empty_vec->is_vector, 'is vector');


## attributes
is_deeply($vec->attributes, undef, 'default attributes');

my $vec_attr = Statistics::R::REXP::Character->new(elements => [3.3, 4.7, 'bar'],
                                                   attributes => { foo => 'bar',
                                                                   x => [40, 41, 42] });
is_deeply($vec_attr->attributes,
          { foo => 'bar', x => [40, 41, 42] }, 'constructed attributes');

my $vec_attr2 = Statistics::R::REXP::Character->new(elements => [3.3, 4.7, 'bar'],
                                                    attributes => { foo => 'bar',
                                                                    x => [40, 41, 42] });
my $another_vec_attr = Statistics::R::REXP::Character->new(elements => [3.3, 4.7, 'bar'],
                                                           attributes => { foo => 'bar',
                                                                           x => [40, 42, 42] });
is($vec_attr, $vec_attr2, 'equality considers attributes');
isnt($vec_attr, $vec, 'inequality considers attributes');
isnt($vec_attr, $another_vec_attr, 'inequality considers attributes deeply');


## attributes must be a hash
like(exception {
        Statistics::R::REXP::Character->new(attributes => 1)
     }, qr/Attribute \(attributes\) does not pass the type constraint/,
     'setting non-HASH attributes');

## Perl representation
is_deeply($empty_vec->to_pl,
          [], 'empty vector Perl representation');

is_deeply($vec->to_pl,
          [3.3, 4.7, 'bar'], 'Perl representation');

is_deeply($na_heavy_vec->to_pl,
          ['foo', '', undef, 23], 'NA-heavy vector Perl representation');

