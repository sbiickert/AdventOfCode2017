#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day13_test.txt';
my $INPUT_FILE = 'day13_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 13: Packet Scanners";

@input
	==> map( -> $line { $line.split(": ").List })
	==> map( -> ($layer, $depth) {
			Map.new("layer" => $layer, "depth" => $depth, "cycle" => ($depth-1)*2)
		})
	==> my @scanners;

my $pt1 = solve_part_one(@scanners);
say "Part One: the trip severity is $pt1";

my $pt2 = solve_part_two(@scanners);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@scanners) {
	@scanners
		==> grep( -> %sc { %sc{'layer'} == 0 || %sc{'layer'} % %sc{'cycle'} == 0})
		==> map( -> %sc { %sc{'layer'} * %sc{'depth'} })
		==> sum
}

sub solve_part_two(@scanners) {
	my @sorted = @scanners.sort: { %^a{'cycle'} leg %^b{'cycle'} };
	for [0..Inf] -> $delay {
		my $did_hit = False;
		print "\r$delay" if $delay %% 10000;
		for @sorted -> %scanner {
			if will_hit(%scanner, $delay) {
				# say "HIT";
				$did_hit = True;
				last;
			}
		}
		return $delay if $did_hit == False;
		# die if $delay > 10;
	}
	print "\r";
	-1;
}

sub will_hit(%scanner, $delay) {
	# say %scanner;
	return ($delay + %scanner{'layer'}) %% %scanner{'cycle'};
}