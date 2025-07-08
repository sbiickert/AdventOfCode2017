#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day17_test.txt';
my $INPUT_FILE = 'day17_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE")[0];

say "Advent of Code 2017, Day 17: Spinlock";

my $pt1 = solve_part_one($input);
say "Part One: $pt1";

# my $pt2 = solve_part_two(@input);
# say "Part Two: $pt2";

exit( 0 );

sub solve_part_one($step) {
	my @circular = [0];
	my $ptr = 0;
	for 1..2017 -> $i {
		$ptr = ($ptr + $step) % @circular.elems;
		@circular.splice($ptr+1, 0, $i);
		$ptr++;
	}

	return @circular[$ptr+1];
}

sub solve_part_two(@input) {
	return 2;
}
