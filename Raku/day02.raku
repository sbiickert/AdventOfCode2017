#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day02_test.txt';
my $INPUT_FILE = 'day02_challenge.txt';

my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

say "Advent of Code 2017, Day 2: Corruption Checksum";

@input.map( -> $line {
	$line.split("\t")
		==> map( -> $s { $s+0 } ) })
	==> my @spreadsheet;

my $pt1 = solve_part_one(@spreadsheet);
say "Part One: the checksum is $pt1";

my $pt2 = solve_part_two(@spreadsheet);
say "Part Two: the checksum is $pt2";

exit( 0 );

sub solve_part_one(@input) {
	@input.map( -> @row { @row.sort })
		==> map( -> @sortedRow { @sortedRow[*-1] - @sortedRow[0] })
		==> sum()
}

sub solve_part_two(@input) {
	@input.map( -> @row { @row.sort.reverse })
		==> map ( -> @row {
			my $rowChecksum = 0;
			for @row.combinations(2) -> @pair {
				if @pair[0] % @pair[1] == 0 {
					$rowChecksum = @pair[0] / @pair[1];
					last;
				}
			}
			$rowChecksum;
		})
		==> sum()
}
