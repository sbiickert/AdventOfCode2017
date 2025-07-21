#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day22_test.txt';
my $INPUT_FILE = 'day22_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 22: Sporifica Virus";

my $mid = (@input.end / 2).Int;
my $start_coord = Coord.from_ints($mid, $mid);
my $start_pos = Position.new(coord => $start_coord, dir => "^");

my $grid = Grid.new(default => ".", rule => AdjacencyRule::ROOK);
$grid.load(@input);

my $pt1 = solve_part_one($grid, $start_pos, 10000);
say "Part One: $pt1 bursts caused a node to become infected";

$grid.load(@input);

my $pt2 = solve_part_two($grid, $start_pos, 10000000);
say "Part Two: $pt2 bursts caused a node to become infected";

exit( 0 );

sub solve_part_one(Grid $grid, Position $start, Int $bursts) {
	my $pos = $start;
	my $burst_to_infected_count = 0;
	for 1..$bursts -> $b {
		my $current_state = $grid.get_glyph($pos.coord);
		given $current_state {
			when '#' {
				$pos = $pos.turn('R');
				$grid.set($pos.coord, '.');
			}
			when '.' {
				$pos = $pos.turn('L');
				$grid.set($pos.coord, '#');
				$burst_to_infected_count++;
			}
		}
		$pos = $pos.move_forward;
	}

	return $burst_to_infected_count;
}

sub solve_part_two(Grid $grid, Position $start, Int $bursts) {
	my $pos = $start;
	my $burst_to_infected_count = 0;
	for 1..$bursts -> $b {
		say $b if $b %% 100000;
		my $current_state = $grid.get_glyph($pos.coord);

		# Interestingly, using if/elsif/else is 10% faster than given/when
		# Implemented "turn_fast" and cut another 50% off time
		if $current_state eq "#" { # Infected
			$pos.turn_fast(1); # turn right
			$grid.set($pos.coord, 'F');
		}
		elsif $current_state eq '.' { # Clean
			$pos.turn_fast(-1); # turn left
			$grid.set($pos.coord, 'W');
		}
		elsif $current_state eq 'W' { # Weakened
			# No turn
			$grid.set($pos.coord, '#');
			$burst_to_infected_count++;
		}
		else { # 'F' # Flagged
			$pos.turn_fast(1); $pos.turn_fast(1); # Reverse by turning right twice
			$grid.set($pos.coord, '.');
		}
		$pos = $pos.move_forward;
	}

	return $burst_to_infected_count;
}
