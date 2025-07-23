#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day25_test.txt';
my $INPUT_FILE = 'day25_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 25: The Halting Problem";

my %blueprint = parse_blueprint(@input);

my $start_state = "A";
my $steps = %blueprint.elems == 2 ?? 6 !! 12964419;

my $pt1 = solve_part_one($start_state, $steps, %blueprint);
say "Part One: the diagnostic checksum is $pt1";

exit( 0 );

sub solve_part_one(Str $start_state, Int $steps, %blueprint) {
	my %tape;
	my $state = $start_state;
	my $ptr = 0;

	for 1..$steps -> $s {
		say $s if $s %% 100000;
		my $current = %tape{$ptr}:exists ?? %tape{$ptr} !! 0;
		my %cond = %blueprint{$state}{$current};
		%tape{$ptr} = %cond{'write'};
		$state = %cond{'next'};
		$ptr += %cond{'move'};
	}

	return %tape.values.sum;
}

sub parse_blueprint(@input) {
	my %bp;

	for @input -> @g {
		my %state = parse_bp_state(@g);
		%bp{%state{'name'}} = %state;
	}
	# say %bp;

	%bp;
}

sub parse_bp_state(@g) {
	my @group = @g.flat;
	my %state;

	my $line = @group.shift;
	$line ~~ /state \s (\w):/;
	%state{'name'} = $/[0];

	%state{0} = parse_bp_condition(@group[1..3]);
	%state{1} = parse_bp_condition(@group[5..7]);

	%state;
}

sub parse_bp_condition(@c) {
	my @lines = @c.flat;
	@lines[0] ~~ /(\d)/;
	my %info;
	%info{'write'} = $/[0];
	@lines[1] ~~ /(\w+)\./;
	%info{'move'} = $/[0] eq 'left' ?? -1 !! 1;
	@lines[2] ~~ /(\w+)\./;
	%info{'next'} = $/[0];
	%info;
}