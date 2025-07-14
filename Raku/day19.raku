#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day19_test.txt';
my $INPUT_FILE = 'day19_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

my $tubes = Grid.new(default => " ", rule => AdjacencyRule::ROOK);
$tubes.load(@input);
# $tubes.print;
my $start = find_start_point($tubes);
# say $start;

say "Advent of Code 2017, Day 19: A Series of Tubes";

my ($pt1, $pt2) = solve_parts($tubes, $start);
say "Part One: the observed letters are $pt1";
say "Part Two: the number of steps is $pt2";

exit( 0 );

sub solve_parts(Grid $tubes, Coord $start) {
	my $pos = Position.new(coord => $start, dir => "v");
	my $letters = "";
	my $steps = 0;

	while True {
		given whats_here($tubes, $pos) {
			when "|" -> { }
			when "-" -> { }
			when "+" -> {
				my $whats_left = whats_near($tubes, $pos, "L");
				if $whats_left eq " " {
					$pos = $pos.turn("CW")
				}				
				else {
					$pos = $pos.turn("CCW")
				}
			}
			when " " -> { }
			default {
				$letters ~= $_;
			}
		}
		last if whats_near($tubes, $pos, "AHEAD") eq " ";
		$pos = $pos.move_forward;
		$steps++;
	}

	return ($letters, $steps);
}

sub whats_here(Grid $tubes, Position $pos) {
	$tubes.get_glyph($pos.coord);
}

sub whats_near(Grid $tubes, Position $pos, Str $dir) {
	my $near;
	given $dir {
		when "L" -> { $near = $pos.turn("CCW") }
		when "R" -> { $near = $pos.turn("CW") }
		when "AHEAD" -> { $near = $pos }
	}
	my $ahead = $near.move_forward;
	$tubes.get_glyph($ahead.coord);
}

sub find_start_point(Grid $tubes) {
	for $tubes.extent.x_range -> $x {
		my $value = $tubes.get_glyph(Coord.from_ints($x, 0));
		if $value eq "|" {
			return Coord.from_ints($x, -1)
		}
	}
}