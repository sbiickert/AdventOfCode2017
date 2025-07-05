#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day12_test.txt';
my $INPUT_FILE = 'day12_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 12: Digital Plumber";

my %connections = parse_connections(@input);
my %groups;
build_group(%connections, %groups, "0", "0");
for %connections.keys -> $other {
	if %groups{$other}:!exists {
		build_group(%connections, %groups, $other, $other);
	}
}

my %summary = count_values(%groups.values);

my $pt1 = %summary{"0"};
say "Part One: the number of programs in group 0 is $pt1";

my $pt2 = %summary.elems;
say "Part Two: the total number of groups is $pt2";

exit( 0 );

sub parse_connections(@input) {
	my %conns;
	for @input -> $line {
		my ($program, $connected) = $line.split(" <-> ");
		my @connected = $connected.split(", ");
		%conns{$program} = @connected;
	}
	%conns;
}

sub build_group(%connections, %groups, $program, $group) {
	%groups{$program} = $group;
	for %connections{$program}.flat -> $conn {
		if %groups{$conn}:!exists {
			build_group(%connections, %groups, $conn, $group);
		}
	}
}