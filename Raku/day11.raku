#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day11_test.txt';
my $INPUT_FILE = 'day11_challenge.txt';
my $input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0)[0];

say "Advent of Code 2017, Day 11: Hex Ed";

my @directions = $input.split(",");

my $pt1 = solve_part_one(@directions);
say "Part One: the child process is $pt1 away";

my $pt2 = solve_part_two(@directions);
say "Part Two: the child process got as far as $pt2";

exit( 0 );

sub solve_part_one(@directions) {
	my %h = count_values(@directions);
	for ['n','s','nw','ne','sw','se'] -> $dir {
		%h{$dir} = max(%h{$dir}, 0);
	}
	measure_distance(%h);
}

sub solve_part_two(@directions) {
	my %h = 'n'=>0,'s'=>0,'nw'=>0,'ne'=>0,'sw'=>0,'se'=>0;
	my $maximum = 0;
	for @directions -> $dir {
		%h{$dir}++;
		$maximum = max($maximum, measure_distance(%h.clone));
	}
	return $maximum;
}

sub measure_distance(%direction_counts) {
	# Cancel out
	cancel_direction(%direction_counts, "n", "s");
	cancel_direction(%direction_counts, "nw", "se");
	cancel_direction(%direction_counts, "ne", "sw");

	# Add Up
	cancel_direction(%direction_counts, "ne", "s", "se");
	cancel_direction(%direction_counts, "nw", "s", "sw");
	cancel_direction(%direction_counts, "se", "n", "ne");
	cancel_direction(%direction_counts, "sw", "n", "nw");
	cancel_direction(%direction_counts, "nw", "ne", "n");
	cancel_direction(%direction_counts, "sw", "se", "s");

	%direction_counts.values.sum;
}

sub cancel_direction(%direction_counts, $dir1, $dir2, $to_dir=Nil) {
	my $minimum = min(%direction_counts{$dir1}, %direction_counts{$dir2});
	%direction_counts{$dir1} -= $minimum;
	%direction_counts{$dir2} -= $minimum;
	with $to_dir { %direction_counts{$to_dir} += $minimum }
}
