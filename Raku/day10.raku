#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use Knot_Hash; # Developed on Day 10

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day10_test.txt';
my $INPUT_FILE = 'day10_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE")[0];

say "Advent of Code 2017, Day 10: Knot Hash";

my $size = $INPUT_FILE ~~ /test/ ?? 4 !! 255;
my $pt1 = solve_part_one($input, $size);
say "Part One: the result of multiplying the first two values is $pt1";

my $pt2 = solve_part_two($input);
say "Part Two: the knot hash is $pt2";

exit( 0 );

sub solve_part_one($input, $size) {
	$input.split(',') ==> map( -> $s {$s+0}) ==> my Int @lengths;
	my @sparse_hash = mk_sparse_knot_hash(@lengths);
	return @sparse_hash[0] * @sparse_hash[1];
}

sub solve_part_two($input) {
	my $hex_str = mk_hex_knot_hash($input, 64);
}
