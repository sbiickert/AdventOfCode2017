#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day16_test.txt';
my $INPUT_FILE = 'day16_challenge.txt';
my $input = read_input("$INPUT_PATH/$INPUT_FILE")[0];

say "Advent of Code 2017, Day 16: Permutation Promenade";

my @moves = $input.split(',').map(&parse_move);
my @programs = @moves.elems < 10 ?? ["a".."e"] !! ["a".."p"];

my $pt1 = solve_part_one(@moves, @programs.clone);
say "Part One: the final program order is $pt1 after one dance";

my $pt2 = solve_part_two(@moves,@programs);
say "Part Two: the final program order is $pt2 after a billion dances";

exit( 0 );

sub solve_part_one(@moves, @programs) {
	for @moves -> $move {
		$move(@programs);
	}
	return @programs.join('');
}

sub solve_part_two(@moves, @programs) {
	my %repeat_tracker = @programs.join('') => 0;
	my $billion = 1000000000;

	for 1..$billion -> $i {
		for @moves -> $move {
			$move(@programs);
		}

		my $state = @programs.join('');
		if %repeat_tracker{$state}:exists {
			# say "Found $state at dance $i first seen at " ~ %repeat_tracker{$state};
			my $target_index = $billion % ($i - %repeat_tracker{$state});
			my $result = %repeat_tracker.pairs.grep( -> $pair {$pair.value == $target_index}).head;
			return $result.key;
		}
		%repeat_tracker{$state} = $i;
	}
	return "@programs.join('')"; # Never gets here, repeated state found earlier
}

sub parse_move($str) {
	# Moves are functions
	given $str.substr(0,1) {
		when "s" -> { $str ~~ /(\d+)/;
			return -> @programs {
				my $value = $/[0]+0;
				spin($value, @programs);
			} }
		when "x" -> { $str ~~ /(\d+) \/ (\d+)/;
			return -> @programs {
				my $pos_a = $/[0]+0;
				my $pos_b = $/[1]+0;
				exchange($pos_a, $pos_b, @programs);
			} }
		when "p" -> { $str ~~ /(\w) \/ (\w)/; 
			return -> @programs {
				my $name_a = $/[0].Str;
				my $name_b = $/[1].Str;
				partner($name_a, $name_b, @programs);
			} }
	}
}

sub spin(Int $value, @programs) {
	my $v = @programs.elems - ($value % @programs.elems);
	my @start = @programs[0..^$v];
	@programs.splice(0, $v);
	@programs.append(|@start);
}

sub exchange(Int $pos_a, Int $pos_b, @programs) {
	my $temp = @programs[$pos_a];
	@programs[$pos_a] = @programs[$pos_b];
	@programs[$pos_b] = $temp;
}

sub partner(Str $name_a, Str $name_b, @programs) {
	my Int $idx_a = @programs.first: * eq $name_a, :k;
	my Int $idx_b = @programs.first: * eq $name_b, :k;
	exchange($idx_a, $idx_b, @programs);
}