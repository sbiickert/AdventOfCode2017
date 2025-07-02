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

my ($name, $weight) = solve_part_two(@programs, $pt1);
say "Part Two: the weight of $name should be $weight";

exit( 0 );

sub solve_part_one(@programs) {
	my %info = buildSupportInfo(@programs);

	for %info.kv -> $name, $supportedBy {
		return $name if $supportedBy eq "";
	}

	return "";
}

sub solve_part_two(@programs, $bottom) {
	my %dict;
	for @programs -> %program {
		%dict{%program{"name"}} = %program;
	}
	calcTotalWeight %dict, $bottom;
	return findUnevenProgram %dict, $bottom;
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

sub calcTotalWeight(%dict, $name) {
	my $subWeight = 0;
	my %program = %dict{$name};
	my @subs = %program{"subprograms"}.flat;
	for @subs -> $subName {
		calcTotalWeight(%dict, $subName);
		$subWeight += %dict{$subName}{"total"};
	}
	%dict{$name}{"total"} = %dict{$name}{"weight"} + $subWeight;
}

sub findUnevenProgram(%dict, $name) {
	my %program = %dict{$name};
	my @subs = %program{"subprograms"}.flat;
	my @u_weights = @subs.map( -> $s { %dict{$s}{"total"} }).unique;
	my @result = ();
	if @u_weights.elems > 1 { # More than one unique weight indicates not all are subs weigh the same
		my %classified = @subs.classify({ %dict{$_}{"total"} == @u_weights[0] ?? @u_weights[0] !! @u_weights[1] }, :as{%dict{$_}{"name"}});
		my ($uneven_idx, $even_idx) = %classified{@u_weights[0]}.elems == 1 ?? (0,1) !! (1,0);
		my $unevenName = %classified{@u_weights[$uneven_idx]}[0]; # The name of the subprogram that has the different weight
		@result = findUnevenProgram %dict, $unevenName;
		if @result.elems == 0 {
			my $diff = @u_weights[$even_idx] - @u_weights[$uneven_idx];
			@result = ($unevenName, %dict{$unevenName}{"weight"} + $diff);
		}
	}
	else {
		for @subs -> $subName {
			@result = findUnevenProgram %dict, $subName;
			last if @result.elems > 0;
		}
	}
	return @result;
}