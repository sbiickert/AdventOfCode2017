#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day10_test.txt';
my $INPUT_FILE = 'day10_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 10: Knot Hash";

@input.split(',') ==> map( -> $s {$s+0}) ==> my Int @lengths;

my $size = $INPUT_FILE ~~ /test/ ?? 4 !! 255;
my $pt1 = solve_part_one(@lengths, $size);
say "Part One: $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@lengths, $size) {
	my Int @numbers = [0..$size];
	my $position = 0;
	my $skip_size = 0;
	($position,$skip_size) = knot_hash(@numbers, @lengths, $position, $skip_size);
	return @numbers[0] * @numbers[1];
}

sub solve_part_two(@input) {
	return 2;
}

sub knot_hash(Int @numbers, Int @lengths, Int $start_pos, Int $start_skip_size) {
	my $pos = $start_pos;
	my $skip_size = $start_skip_size;
	for @lengths -> $length {
		my Int $end = $pos + $length - 1;
		reverse_numbers(@numbers, $pos, $end);
		# say "$pos, $skip_size " ~ @numbers;
		$pos = ($pos + $length + $skip_size) % @numbers.elems;
		$skip_size++;
	}
	($pos, $skip_size);
}

sub reverse_numbers(@numbers, Int $start, Int $end) {
	# say @numbers ~ " start: $start  end: $end";
	my @numbers_to_reverse = @numbers[$start..min(@numbers.end, $end)];
	my $overrun = 0;
	if $end > @numbers.end {
		$overrun = $end - @numbers.end;
		@numbers_to_reverse.push(|@numbers[0..$end % @numbers.elems]);
	}

	# say @numbers_to_reverse;
	my @reversed_numbers = @numbers_to_reverse.reverse;
	# say @reversed_numbers;

	my @splice1 = @reversed_numbers[0..@reversed_numbers.end-$overrun];
	@numbers.splice($start, @splice1.elems, @splice1);
	if $overrun > 0 {
		my @overrun_splice = @reversed_numbers[*-$overrun..*];
		@numbers.splice(0, @overrun_splice.elems, @overrun_splice);
	}
	# say @numbers;
}