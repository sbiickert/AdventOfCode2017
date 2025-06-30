#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day03_test.txt';
my $INPUT_FILE = 'day03_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

say "Advent of Code 2017, Day 3: Spiral Memory";

my $square = @input[0]+0;

my $pt1 = solve_part_one($square);
say "Part One: $pt1 steps are needed to carry data from $square";

my $pt2 = solve_part_two($square);
say "Part Two: the first value larger than $square is $pt2";

exit( 0 );

sub solve_part_one($square) {
	for 1, * + 2 ... * -> $i { # Infinite sequence of odd numbers
		my $max_square = $i ** 2;
		if $max_square >= $square {
			# We know the "ring" that the square is in.
			my $ring_distance = ($i - 1) / 2;
			# Now calculate the offset towards corners
			my $max_inner_square = max(0, $i-2) ** 2; # Biggest value on the ring inside this one
			my $ring_square_count = $max_square - $max_inner_square; # Count of the squares in this ring
			my $ring_index = $max_square - $square; # 0 is the last square before jumping to next ring, a corner
			my $side_index = $ring_index % ($ring_square_count / 4);
			my $corner_distance = abs($side_index - $ring_distance);
			return $ring_distance + $corner_distance;
		}
	}
}

sub solve_part_two($square) {
	my $grid = Grid.new(default => 0, rule => AdjacencyRule::QUEEN);
	$grid.set(Coord.origin, 1);
	my $pos = Position.new(coord => Coord.origin, dir => '>');
	$pos = $pos.move_forward;
	while True {
		$grid.neighbors($pos.coord)
			==> map( -> $n { $grid.get($n) })
			==> grep( -> $v { $v > 0 })
			==> my @neighbor_values;
		my $sum_of_neighbors = @neighbor_values.sum;
		$grid.set($pos.coord, $sum_of_neighbors);
		if $sum_of_neighbors > $square {
			return $sum_of_neighbors;
		}
		$pos = $pos.turn("CCW") if @neighbor_values.elems <= 2;
		$pos = $pos.move_forward;
	}
	return 0;
}
