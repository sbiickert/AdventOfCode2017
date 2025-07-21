#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day22_test.txt';
my $INPUT_FILE = 'day22_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

my $bursts = 10000;

say "Advent of Code 2017, Day 22: Sporifica Virus";

my $grid = Grid.new(default => ".", rule => AdjacencyRule::ROOK);
$grid.load(@input);
my $mid = (@input.end / 2).Int;
my $start_coord = Coord.from_ints($mid, $mid);
my $start_pos = Position.new(coord => $start_coord, dir => "^");

# $grid.print(markers => {$start_pos.coord => $start_pos.dir});


my $pt1 = solve_part_one($grid, $start_pos, $bursts);
say "Part One: $pt1 bursts caused a node to become infected";

# my $pt2 = solve_part_two($grid, $start_pos, $bursts);
# say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(Grid $grid, Position $start, Int $bursts) {
	my $pos = $start;
	my $burst_to_infected_count = 0;
	for 1..$bursts -> $b {
		my $current_state = $grid.get_glyph($pos.coord);
		given $current_state {
			when '#' -> {
				$pos = $pos.turn('CW');
				$grid.set($pos.coord, '.');
			}
			when '.' -> {
				$pos = $pos.turn('CCW');
				$grid.set($pos.coord, '#');
				$burst_to_infected_count++;
			}
		}
		$pos = $pos.move_forward;
		# $grid.print(markers => {$pos.coord => $pos.dir});
		# say "";
	}

	return $burst_to_infected_count;
}

sub solve_part_two(Grid $grid, Position $start, Int $bursts) {
	return 2;
}
