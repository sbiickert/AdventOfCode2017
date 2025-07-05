#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day13_test.txt';
my $INPUT_FILE = 'day13_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 13: Packet Scanners";

@input
	==> map( -> $line { $line.split(": ").List })
	==> map( -> ($layer, $depth) { {$layer,$depth,($depth-1)*2} })
	==> my @scanners;

my $pt1 = solve_part_one(@scanners);
say "Part One: the trip severity is $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@scanners) {
	@scanners
		==> grep( -> ($layer,$depth,$cycle) { $layer == 0 || $layer % $cycle == 0})
		==> map( -> ($layer,$depth,$cycle) { $layer * $depth})
		==> sum
}

sub solve_part_two(@input) {
	return 2;
}
