#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
my $INPUT_FILE = 'day<##>_test.txt';
#my $INPUT_FILE = 'day<##>_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code <##>, Day <##>: <##>";

my $pt1 = solve_part_one(@input);
say "Part One: $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@input) {
	return 1;
}

sub solve_part_two(@input) {
	return 2;
}
