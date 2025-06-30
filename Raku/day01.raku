#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day01_test.txt';
my $INPUT_FILE = 'day01_challenge.txt';
my $input = read_grouped_input("$INPUT_PATH/$INPUT_FILE")[0][0];

say "Advent of Code 2024, Day 1: Inverse Captcha";

$input.split("", :skip-empty)
    ==> map( -> $x {$x+0})
    ==> my @numbers;

my $pt1 = solve_part(@numbers, 1);
say "Part One: the captcha is $pt1";

my $pt2 = solve_part(@numbers, @numbers.elems / 2);
say "Part Two: the captcha is $pt2";

exit( 0 );

sub solve_part(@numbers, $lookAhead) {
    my $result = 0;
	for @numbers.kv -> $index, $value {
        if $index < @numbers.elems {
            my $next = ($index + $lookAhead) % @numbers.elems;
            $result += $value if @numbers[$next] == $value;
        }
    }
    return $result;
}
