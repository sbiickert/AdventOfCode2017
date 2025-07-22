#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
my $INPUT_FILE = 'day23_test.txt';
#my $INPUT_FILE = 'day23_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 23: Coprocessor Conflagration";

class Day23Program {...}

my @instructions = @input.map(&parse_instruction);

my $pt1 = solve_part_one(@instructions);
say "Part One: mul instructions were called $pt1 times";

my $pt2 = solve_part_two();
say "Part Two: the value left in register h is $pt2";

exit( 0 );

sub solve_part_one(@instructions) {
	my $program = Day23Program.new(instructions => @instructions);
	while $program.has_valid_ptr {
		$program.execute_instruction;
	}
	return $program.mul_count;
}

sub solve_part_two() {
	# Can't run the virtual software from part 1 in less than infinite time.
	# This is the logic inside the program.
	my $h = 0;
	loop (my $i = 106700; $i <= 123700; $i += 17) {
		if !$i.is-prime { $h++ }
	}
	return $h;
}

sub parse_instruction($line) {
	my $name = $line.substr(0..2);
	my %instr = 'name' => $name;

	given $name {
		when "set" -> { $line ~~ / \s (\w) \s (\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "sub" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "mul" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "jnz" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
	}
	%instr;
}

# Simplified, modified version of Day 18
class Day23Program {
	has @.instructions = [];
	has Int $.ptr = 0;
	has %.registers = {};
	has Int $.mul_count = 0;

	submethod TWEAK() {
		for @!instructions -> %i {
			%!registers{%i{'arg1'}} = 0;
		}
	}

	method value_of($arg --> Int) {
		if $arg ~~ /\d/ {
			return $arg+0;
		}
		elsif %.registers{$arg}:!exists {
			%.registers{$arg} = 0;
		}
		return %.registers{$arg}+0;
	}

	method execute_instruction( --> Bool) {
		my %i = @.instructions[$!ptr];
		given %i{'name'} {
			when "set" -> {
				%.registers{%i{'arg1'}} = self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "sub" -> {
				%.registers{%i{'arg1'}} -= self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "mul" -> {
				%.registers{%i{'arg1'}} *= self.value_of(%i{'arg2'});
				$!ptr++;
				$!mul_count++;
			}
			when "jnz" -> {
				if self.value_of(%i{'arg1'}) != 0 {
					$!ptr += self.value_of(%i{'arg2'});
				}
				else {
					$!ptr++;
				}
			}
		}

		self.has_valid_ptr;
	}

	method has_valid_ptr(--> Bool) {
		$.ptr >= 0 && $.ptr <= @.instructions.end;
	}
}