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

my $pt1 = solve_part(@input, True);
say "Part One: it takes $pt1 steps to reach the exit";

my $pt2 = solve_part(@input, False);
say "Part Two: it takes $pt2 steps to reach the exit";

exit( 0 );

sub solve_part(@input, Bool $alwaysIncreasing) {
	my @jumps = @input.map( -> $line { $line+0 });
	my $ptr = 0;
	my $steps = 0;

	while $ptr <= @jumps.end {
		my $jump = @jumps[$ptr];
		if $alwaysIncreasing || $jump < 3 	{ @jumps[$ptr] = $jump + 1; }
		else 								{ @jumps[$ptr] = $jump - 1; }
		$ptr += $jump;
		$steps++;
	}

	return $steps;
}

