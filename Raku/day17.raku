#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day17_test.txt';
my $INPUT_FILE = 'day17_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE")[0];

say "Advent of Code 2017, Day 17: Spinlock";

my $pt1 = solve_part_one($input+0);
say "Part One: the number after 2017 is $pt1";

my $pt2 = solve_part_two($input+0);
say "Part Two: the number after 0 is $pt2";

exit( 0 );

sub solve_part_one(Int $step) {
	my @circular = [0];
	my $current = 0;

	for 1..2017 -> $i {
		$current = ($current + $step) % $i;
		@circular.splice(++$current, 0, $i);
	}

	@circular[$current+1];
}

sub solve_part_two(Int $step) {
	my $current = 0;
	my $after_zero = -1;

	for 1..50000000 -> $i {
		$current = ($current + $step) % $i;
		if $current++ == 0 { $after_zero = $i }
	}

	$after_zero;
}
