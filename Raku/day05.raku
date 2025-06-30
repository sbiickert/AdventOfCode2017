#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day05_test.txt';
my $INPUT_FILE = 'day05_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 5: A Maze of Twisty Trampolines, All Alike";

my $pt1 = solve_part_one(@input);
say "Part One: it takes $pt1 steps to reach the exit";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@input) {
	my @jumps = @input.map( -> $line { $line+0 });
	my $ptr = 0;
	my $steps = 0;

	while $ptr >= 0 && $ptr <= @jumps.end {
		my $jump = @jumps[$ptr];
		# say "step: $steps  ptr: $ptr  jumps: " ~ @jumps;
		@jumps[$ptr]++;
		$ptr += $jump;
		$steps++;
	}

	return $steps;
}

sub solve_part_two(@input) {
	return 2;
}
