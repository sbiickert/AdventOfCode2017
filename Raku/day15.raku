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
	for 1..40000000 {
		$gen_a_value = ($gen_a_value * $gen_a_factor) % 2147483647; 
		$gen_b_value = ($gen_b_value * $gen_b_factor) % 2147483647;
		$count_matches++ if values_match_2($gen_a_value, $gen_b_value);
	}
	$count_matches;
}

sub solve_part_two(@input) {
	return 2;
}


sub values_match_1($value_a, $value_b) {
	# say "$value_a, $value_b";
	my $l16_a = sprintf("%032b\n", $value_a).substr(16);
	my $l16_b = sprintf("%032b\n", $value_b).substr(16);
	$l16_a eq $l16_b;
}

sub values_match_2($value_a, $value_b) {
	# say "$value_a, $value_b";
	my ($a,$b) = $value_a, $value_b;
	my $result = True;
	for 0..15 {
		my $bit_a = $a +& 1;
		my $bit_b = $b +& 1;
		if $bit_a != $bit_b {
			$result = False;
			last;
		}
		$a +>= 1;
		$b +>= 1;
	}
	$result;
}