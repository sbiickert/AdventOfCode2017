#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day04_test.txt';
my $INPUT_FILE = 'day04_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

say "Advent of Code 2017, Day 4: High-Entropy Passphrases";

my $pt1 = solve_part_one(@input);
say "Part One: there are $pt1 valid passphrases";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@input) {
	my @valid = @input.grep(&passphraseIsValid);
	return @valid.elems;
}

sub solve_part_two(@input) {
	return 2;
}

sub passphraseIsValid($pass) {
	my %words_db;
	my @words = $pass.split(" ");
	for @words -> $word {
		%words_db{$word} = 1;
	}
	return @words.elems == %words_db.elems;
}