#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;
use Knot_Hash; # Developed on Day 10


my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day14_test.txt';
my $INPUT_FILE = 'day14_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE").head;

say "Advent of Code 2017, Day 14: Disk Defragmentation";

my $disk = load_grid($input);

my $pt1 = solve_part_one($disk);
say "Part One: the number of used squares is $pt1";

my $pt2 = solve_part_two($disk);
say "Part Two: the number of regions is $pt2";

exit( 0 );

sub solve_part_one(Grid $disk) {
	my %hist = $disk.histogram;
	return %hist{"#"};
}

sub solve_part_two(Grid $disk) {
	my @used = $disk.coords("#");
	my @letters = "A".."Z"; # Need to set to something other than #. Letters aid visualization.
	my $count = 0;
	my $ptr = 0;

	for @used -> $coord {
		if $disk.get($coord) eq "#" {
			$disk.flood_fill($coord, @letters[$ptr++]);
			$count++;
			$ptr = $ptr % @letters.elems;
		}
	}
	# $disk.print;
	return $count;
}

sub load_grid($input) {
	my $grid = Grid.new(default => ".", rule => AdjacencyRule::ROOK);

	for 0..127 -> $row {
		my $hash = mk_hex_knot_hash("$input-$row", 64);
		my @hash_chars = $hash.split("", :skip-empty);

		@hash_chars.map( -> $hex {"0x$hex"})
		==> map( -> $hex {sprintf "%04b", $hex})
		==> join("")
		==> split("", :skip-empty)
		==> my @row_binary;
		
		for 0..127 -> $col {
			$grid.set(Coord.new(x=>$col,y=>$row), "#") if @row_binary[$col] eq "1";
		}
	}
	# $grid.print;
	$grid;
}