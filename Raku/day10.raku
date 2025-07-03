#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day10_test.txt';
my $INPUT_FILE = 'day10_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE")[0];

say "Advent of Code 2017, Day 10: Knot Hash";

my $size = $INPUT_FILE ~~ /test/ ?? 4 !! 255;
my $pt1 = solve_part_one($input, $size);
say "Part One: $pt1";

my $pt2 = solve_part_two($input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one($input, $size) {
	$input.split(',') ==> map( -> $s {$s+0}) ==> my Int @lengths;
	my Int @numbers = [0..$size];
	my $position = 0;
	my $skip_size = 0;
	($position,$skip_size) = knot_hash(@numbers, @lengths, $position, $skip_size);
	return @numbers[0] * @numbers[1];
}

sub solve_part_two($input) {
	my Int @sparse_hash = [0..255];
	$input.split("", :skip-empty) ==> map( -> $c { ord($c) }) ==> my Int @lengths;
	@lengths.push(|[17, 31, 73, 47, 23]);
	my $position = 0;
	my $skip_size = 0;

	for 1..64 {
		($position,$skip_size) = knot_hash(@sparse_hash, @lengths, $position, $skip_size);
	}

	my @dense_hash = get_dense_hash(@sparse_hash);

	@dense_hash
		==> map( -> $n { sprintf "%02x", $n })
		==> join("");
}

sub knot_hash(Int @numbers, Int @lengths, Int $start_pos, Int $start_skip_size) {
	my $pos = $start_pos;
	my $skip_size = $start_skip_size;
	for @lengths -> $length {
		my Int $end = $pos + $length - 1;
		reverse_numbers(@numbers, $pos, $end);
		$pos = ($pos + $length + $skip_size) % @numbers.elems;
		$skip_size++;
	}
	($pos, $skip_size);
}

sub reverse_numbers(@numbers, Int $start, Int $end) {
	my @numbers_to_reverse = @numbers[$start..min(@numbers.end, $end)];
	my $overrun = 0;
	if $end > @numbers.end {
		$overrun = $end - @numbers.end;
		@numbers_to_reverse.push(|@numbers[0..$end % @numbers.elems]);
	}

	my @reversed_numbers = @numbers_to_reverse.reverse;

	my @splice1 = @reversed_numbers[0..@reversed_numbers.end-$overrun];
	@numbers.splice($start, @splice1.elems, @splice1);
	if $overrun > 0 {
		my @overrun_splice = @reversed_numbers[*-$overrun..*];
		@numbers.splice(0, @overrun_splice.elems, @overrun_splice);
	}
}

sub get_dense_hash(@sparse_hash) {
	@sparse_hash.batch(16)
		==> map( -> $block {$block.reduce(&infix:<+^>)}); # Bitwise XOR
}