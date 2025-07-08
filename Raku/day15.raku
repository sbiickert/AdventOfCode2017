#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day15_test.txt';
my $INPUT_FILE = 'day15_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 15: Dueling Generators";

my ($gen_a_start, $gen_b_start) = @input;
my $gen_a_factor := 16807;
my $gen_b_factor := 48271;

my $pt1 = solve_part_one($gen_a_start, $gen_b_start);
say "Part One: the judge's final count is $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one($gen_a_start, $gen_b_start) {
	my $gen_a_value = $gen_a_start;
	my $gen_b_value = $gen_b_start;
	my $count_matches = 0;
	# for 1..40000000 {
	for 1..1000000 {
		$gen_a_value = ($gen_a_value * $gen_a_factor) % 2147483647; 
		$gen_b_value = ($gen_b_value * $gen_b_factor) % 2147483647;
		$count_matches++ if values_match($gen_a_value, $gen_b_value);
	}
	$count_matches;
}

sub solve_part_two(@input) {
	return 2;
}


sub values_match($value_a, $value_b) {
	my $result = True;
	for 0..15 -> $i {
		if $value_a +& (2 ** $i) != $value_b +& (2 ** $i) {
			$result = False;
			last;
		}
	}
	$result;
}
