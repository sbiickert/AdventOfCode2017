#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day06_test.txt';
my $INPUT_FILE = 'day06_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 6: Memory Reallocation";

@input[0].split("\t")
	==> map( -> $n { $n+0 })
	==> my @memory;

my ($pt1, $pt2) = solve(@memory);
say "Part One: the infinite loop is detected after $pt1 iterations";
say "Part Two: the infinite loop is $pt2 iterations long";

exit( 0 );

sub solve(@memory) {
	my %states = ();
	my $state = @memory.join("");
	my $count = 0;

	while %states{$state}:!exists {
		%states{$state} = $count;
		move_blocks(@memory);
		$state = @memory.join("");
		$count++;
	}
	return ($count, $count - %states{$state});
}

sub move_blocks(@memory) {
	my $maxKV = @memory.pairs.max(*.value);
	my $idx = $maxKV.key;
	my $blocksToRealloc = $maxKV.value;
	@memory[$idx] = 0;
	for (1..$blocksToRealloc) {
		$idx = ($idx + 1) % @memory.elems;
		@memory[$idx]++;
	}
}