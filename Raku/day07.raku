#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day07_test.txt';
my $INPUT_FILE = 'day07_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

my @programs = @input.map(&parseProgram);

say "Advent of Code 2017, Day 7: Recursive Circus";

my $pt1 = solve_part_one(@programs);
say "Part One: the bottom program is $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@programs) {
	my %info = buildSupportInfo(@programs);

	for %info.kv -> $name, $supportedBy {
		# say "$name -> " ~ $supportedBy;
		return $name if $supportedBy eq "";
	}

	return "";
}

sub solve_part_two(@input) {
	return 2;
}

sub parseProgram($line) {
	my %program;
	$line ~~ / (\w+) \s \((\d+)\) /;
	%program{"name"} = $0;
	%program{"weight"} = $1 + 0;
	%program{"subprograms"} = Array.new();
	if $line ~~ / \-\> \s (.+) / {
		%program{"subprograms"} = $0.split(", ").Array;
	}
	%program;
}

sub buildSupportInfo(@programs) {
	my %info;
	for @programs -> %program {
		%info{%program{"name"}} = "";
	}

	for @programs -> %program {
		my @subs = %program{"subprograms"}.flat;
		for @subs -> $sub {
			# say "$sub is supported by " ~ %program{"name"};
			%info{$sub} = %program{"name"};
		}
	}
	%info;
}