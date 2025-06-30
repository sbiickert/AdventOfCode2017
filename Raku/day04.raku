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
say "Part Two: there are $pt2 valid passphrases";

exit( 0 );

sub solve_part_one(@input) {
	my @valid = @input.grep(&passphraseIsValid1);
	return @valid.elems;
}

sub solve_part_two(@input) {
	my @valid = @input.grep(&passphraseIsValid2);
	return @valid.elems;
}

sub passphraseIsValid1($pass) {
	my @words = $pass.split(" ");
	my @unique_words = unique_words(@words);
	return @words.elems == @unique_words.elems;
}

sub passphraseIsValid2($pass) {
	my @words = $pass.split(" ");
	my @unique_words = unique_sorted_character_strings(@words);
	return @words.elems == @unique_words.elems;
}

sub unique_words(@words) {
	my %words_db;
	for @words -> $word {
		%words_db{$word} = 1;
	}
	%words_db.keys;
}

sub unique_sorted_character_strings(@words) {
	my @sorted_character_strings = @words.map( -> $w {
		$w.split("", :skip-empty).sort().join("");
	});
	unique_words(@sorted_character_strings);
}