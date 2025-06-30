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
say "Part One: $pt1";

my $pt2 = solve_part_two(@spreadsheet);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@input) {
	@input.map( -> @row { @row.sort })
		==> map( -> @sortedRow { @sortedRow[*-1] - @sortedRow[0] })
		==> sum()
		==> my $checksum;
	return $checksum;
}

sub solve_part_two(@input) {
	@input.map( -> @row {
			my $rowChecksum = 0;
			my @descRow = @row.sort.reverse();
			for 0..@descRow.end-1 -> $i {
				for $i+1..@descRow.end -> $j {
					if @descRow[$i] % @descRow[$j] == 0 {
						$rowChecksum = @descRow[$i] / @descRow[$j];
						last;
					}
				}
			}
			$rowChecksum;
			})
		==> sum()
		==> my $checksum;
	return $checksum;
}
