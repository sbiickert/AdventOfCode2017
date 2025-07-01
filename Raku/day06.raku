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

my $pt1 = solve_part_one(@memory.clone);
say "Part One: the infinite loop is detected after $pt1 iterations";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@memory) {
	my %states = ();
	my $state = @memory.join("");
	my $count = 0;
	say $state;

	while %states{$state}:!exists {
		%states{$state} = 1;
		move_blocks(@memory);
		$state = @memory.join("");
		# say $state;
		$count++;
	}
	return $count;
}

sub solve_part_two(@input) {
	return 2;
}

sub move_blocks(@memory) {
	my $maxKV = @memory.pairs.max(*.value);
	my $idx = $maxKV.key;
	my $blocksToRealloc = $maxKV.value;
	@memory[$idx] = 0;
	$idx++;
	while $blocksToRealloc > 0 {
		$idx = $idx % @memory.elems;
		@memory[$idx]++;
		$blocksToRealloc--;
		$idx++;
	}
}