#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day18_test.txt';
my $INPUT_FILE = 'day18_challenge.txt';

my @input1 = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);
my @instructions1 = @input1.map(&parse_instruction);

say "Advent of Code 2017, Day 18: Duet";

class Day18Program {...}

my $pt1 = solve_part_one(@instructions1);
say "Part One: the last note played was $pt1";

my @input2 = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);
my @instructions2 = @input2.map(&parse_instruction);

my $pt2 = solve_part_two(@instructions2);
say "Part Two: program 1 sent $pt2 times";

exit( 0 );

sub solve_part_one(@instructions) {
	my $program = Day18Program.new(id => 0, part => 1, instructions => @instructions);
	
	my $keep_going = $program.execute_instruction;
	while $keep_going {
		$keep_going = $program.execute_instruction;
	}

	return $program.last_played_note;
}

sub solve_part_two(@instructions) {
	my @programs = (Day18Program.new(id => 0, part => 2, instructions => @instructions),
					Day18Program.new(id => 1, part => 2, instructions => @instructions));
	@programs[0].partner = @programs[1];
	@programs[1].partner = @programs[0];
	
	my $stop = !@programs[0].has_valid_ptr || !@programs[1].has_valid_ptr ||
		(@programs[0].is_waiting && @programs[1].is_waiting);

	while !$stop {
		for @programs -> $program { $program.execute_instruction }
		my $deadlock = @programs[0].is_waiting && @programs[1].is_waiting;
		$stop = !@programs[0].has_valid_ptr || !@programs[1].has_valid_ptr || $deadlock;
	}

	return @programs[1].snd_count;
}


class Day18Program {
	has Int $.id;
	has Int $.part;
	has @.instructions = [];
	has Int $.ptr = 0;
	has %.registers = {};
	has Int $.last_played_note = -1;
	has Day18Program $.partner is rw = Nil;
	has Int $.snd_count = 0;
	has Int @.rcv_queue = [];

	submethod TWEAK() {
		for @!instructions -> %i {
			%!registers{%i{'arg1'}} = 0;
		}
		%!registers{'p'} = $!id if $!part == 2;
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
			when "snd" -> {
				if $.part == 1 {
					$!last_played_note = self.value_of(%i{'arg1'});
				}
				else {
					self.snd(self.value_of(%i{'arg1'}));
				}
				$!ptr++;
			}
			when "rcv" -> {
				if $.part == 1 {
					if self.value_of(%i{'arg1'}) != 0 { $!ptr = -1 }
					else { $!ptr++ }
				}
				else {
					if $.rcv_queue.elems > 0 {
						my $value = $.rcv_queue.shift;
						%.registers{%i{'arg1'}} = $value;
						$!ptr++;
					}
				}
			}
			when "set" -> {
				%.registers{%i{'arg1'}} = self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "add" -> {
				%.registers{%i{'arg1'}} += self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "mul" -> {
				%.registers{%i{'arg1'}} *= self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "mod" -> {
				%.registers{%i{'arg1'}} %= self.value_of(%i{'arg2'});
				$!ptr++;
			}
			when "jgz" -> {
				if self.value_of(%i{'arg1'}) > 0 {
					$!ptr += self.value_of(%i{'arg2'});
				}
				else {
					$!ptr++;
				}
			}
		}

		self.has_valid_ptr;
	}

	method rcv(Int $value) {
		$.rcv_queue.push($value);
	}

	method snd(Int $value) {
		$!snd_count++;
		$.partner.rcv($value);
	}

	method has_valid_ptr(--> Bool) {
		$.ptr >= 0 && $.ptr <= @.instructions.end;
	}

	method is_waiting(--> Bool) {
		my %i = @.instructions[$!ptr];
		%i{'name'} eq 'rcv' && $.rcv_queue.elems == 0;
	}
}

sub parse_instruction($line) {
	my $name = $line.substr(0..2);
	my %instr = 'name' => $name;

	given $name {
		when "snd" -> { $line ~~ / \s (\w)/;
			%instr{'arg1'} = $/[0].Str;
		}
		when "set" -> { $line ~~ / \s (\w) \s (\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "add" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "mul" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "mod" -> { $line ~~ / \s (\w) \s (\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
		when "rcv" -> { $line ~~ / \s (\w)/;
			%instr{'arg1'} = $/[0].Str;
		}
		when "jgz" -> { $line ~~ / \s (\w) \s (\-?\w+)/;
			%instr{'arg1'} = $/[0].Str;
			%instr{'arg2'} = $/[1].Str;
		}
	}
	%instr;
}