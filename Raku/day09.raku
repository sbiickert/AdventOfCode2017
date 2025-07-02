#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day09_test.txt';
my $INPUT_FILE = 'day09_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

say "Advent of Code 2017, Day 9: Stream Processing";

my ($pt1,$pt2) = solve(@input[0]);
say "Part One: the group score is $pt1";
say "Part Two: the total garbage is $pt2";

exit( 0 );

sub solve(Str $stream) {
	my $depth = 0;
	my $score = 0;
	my $in_garbage = False;
	my $garbage_count = 0;

	my @stream = $stream.split('', :skip-empty);
	my $ptr = 0;
	while $ptr <= @stream.end {
		if @stream[$ptr] eq "!" { $ptr += 2; next }

		if $in_garbage && @stream[$ptr] eq ">" {
			$in_garbage = False;
		}

		if $in_garbage {
			$garbage_count++;
		}
		else {
			given @stream[$ptr] {
				when '{' { $depth++ }
				when '}' { $score += $depth; $depth-- }
				when '<' { $in_garbage = True }
			}
		}

		$ptr++;
	}

	return ($score,$garbage_count);
}

