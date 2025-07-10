#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day18_test.txt';
my $INPUT_FILE = 'day18_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

my @instructions = @input.map(&parse_instruction);
# say @instructions;

say "Advent of Code 2017, Day 18: Duet";

my $pt1 = solve_part_one(@instructions);
say "Part One: the last note played was $pt1";

my $pt2 = solve_part_two(@input);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@instructions) {
	my $note_played = 0;
	my $ptr = 0;
	my %registers;

	for @instructions -> %i {
		%registers{%i{'arg1'}} = 0;
	}

	while $ptr >=0 && $ptr <= @instructions.end {
		my %i = @instructions[$ptr];
		# say $ptr, %i;
		given %i{'name'} {
			when "snd" -> {
				$note_played = value_of(%i{'arg1'}, %registers);
				$ptr++;
			}
			when "set" -> {
				%registers{%i{'arg1'}} = value_of(%i{'arg2'}, %registers);
				$ptr++;
			}
			when "add" -> {
				%registers{%i{'arg1'}} += value_of(%i{'arg2'}, %registers);
				$ptr++;
			}
			when "mul" -> {
				%registers{%i{'arg1'}} *= value_of(%i{'arg2'}, %registers);
				$ptr++;
			}
			when "mod" -> {
				%registers{%i{'arg1'}} %= value_of(%i{'arg2'}, %registers);
				$ptr++;
			}
			when "rcv" -> {
				if value_of(%i{'arg1'}, %registers) != 0 {
					$ptr = -1;
				}
				else {
					$ptr++;
				}
			}
			when "jgz" -> {
				if value_of(%i{'arg1'}, %registers) > 0 {
					$ptr += value_of(%i{'arg2'}, %registers)
				}
				else {
					$ptr++;
				}
			}
		}
		# say %registers;
	}

	return $note_played;
}

sub solve_part_two(@input) {
	return 2;
}

sub value_of($arg, %registers) {
	if $arg ~~ /\d/ {
		return $arg;
	}
	elsif %registers{$arg}:!exists {
		%registers{$arg} = 0;
	}
	return %registers{$arg};
}

sub parse_instruction($line) {
	my $name = $line.substr(0..2);
	my %instr = 'name' => $name;

	given $name {
		when "snd" -> { $line ~~ / \s (\w)/;
			%instr{'arg1'} = $/[0];
		}
		when "set" -> { $line ~~ / \s (\w) \s (\w+)/;
			%instr{'arg1'} = $/[0];
			%instr{'arg2'} = $/[1];
		}
		when "add" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0];
			%instr{'arg2'} = $/[1];
		}
		when "mul" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0];
			%instr{'arg2'} = $/[1];
		}
		when "mod" -> { $line ~~ / \s (\w) \s (\w+)/;
			%instr{'arg1'} = $/[0];
			%instr{'arg2'} = $/[1];
		}
		when "rcv" -> { $line ~~ / \s (\w)/;
			%instr{'arg1'} = $/[0];
		}
		when "jgz" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0];
			%instr{'arg2'} = $/[1];
		}
	}
	%instr;
}

