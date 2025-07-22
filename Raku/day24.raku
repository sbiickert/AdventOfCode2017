#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day24_test.txt';
my $INPUT_FILE = 'day24_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 24: Electromagnetic Moat";

my @comps = @input.map(&parse_mag_comp);

my $max_strength = -1;
my @strongest_bridge;

find_strongest_bridge( [], @comps );
say "Part One: the strength of the strongest bridge is $max_strength";

my @longest_bridge;

find_longest_bridge( [], @comps );
say "Part Two: the strength of the longest bridge is {calc_strength(@longest_bridge)}";

exit( 0 );

sub solve_part_one(@comps) {
	find_strongest_bridge( [], @comps );

	say @strongest_bridge;
}

sub solve_part_two(@comps) {
	return 2;
}

sub find_strongest_bridge(@bridge, @available_comps) {
	# say @bridge;
	my $s = calc_strength(@bridge);
	if $s > $max_strength {
		$max_strength = $s;
		@strongest_bridge = @bridge;
	}

	my $end_pins = @bridge.elems == 0 ?? 0 !! @bridge[@bridge.end][1];
	for @available_comps.kv -> $i, @comp {

		if @comp[0] == $end_pins || @comp[1] == $end_pins {
			my @mutable = @comp;
			my @rest = @available_comps.clone;
			@rest.splice($i, 1);
			if @mutable[0] != $end_pins {
				@mutable = @mutable.reverse.List;
			}
			my @new_bridge = @bridge.clone;
			@new_bridge.push(@mutable);
			find_strongest_bridge(@new_bridge, @rest);
		}
	}
}

sub find_longest_bridge(@bridge, @available_comps) {
	# say @bridge;
	if @bridge.elems >= @longest_bridge.elems && calc_strength(@bridge) > calc_strength(@longest_bridge) {
		@longest_bridge = @bridge;
	}

	my $end_pins = @bridge.elems == 0 ?? 0 !! @bridge[@bridge.end][1];
	for @available_comps.kv -> $i, @comp {

		if @comp[0] == $end_pins || @comp[1] == $end_pins {
			my @mutable = @comp;
			my @rest = @available_comps.clone;
			@rest.splice($i, 1);
			if @mutable[0] != $end_pins {
				@mutable = @mutable.reverse.List;
			}
			my @new_bridge = @bridge.clone;
			@new_bridge.push(@mutable);
			find_longest_bridge(@new_bridge, @rest);
		}
	}
}

sub calc_strength(@bridge --> Int) {
	# @bridge ==> map( -> @comp { @comp.sum }) ==> sum; # slower to use the feed operator
	@bridge.map( -> @comp { @comp.sum }).sum;}

sub parse_mag_comp(Str $line) {
	$line.split('/') ==> map( -> $num { $num+0 });
}