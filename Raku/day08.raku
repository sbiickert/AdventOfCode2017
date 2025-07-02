#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
# use MONKEY; # For EVAL

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day08_test.txt';
my $INPUT_FILE = 'day08_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 8: I Heard You Like Registers";

my @instructions = @input.map(&parseInstruction);

my ($pt1,$pt2) = solve(@instructions);
say "Part One: the largest value in an register is $pt1";
say "Part Two: the highest value encountered is $pt2";

exit( 0 );

sub solve(@instructions) {
	my %registers;
	my $highest = 0;

	for @instructions -> %i {
		%registers{%i{'target'}} = 0	if %registers{%i{'target'}}:!exists;
		%registers{%i{'reg'}} = 0		if %registers{%i{'reg'}}:!exists;

		# Tried using EVAL, but it was much slower. Leaving here for reference.
		# my $comp_result = EVAL '$comp_result = %registers{%i{"reg"}} ' ~ %i{'cmp'} ~ ' %i{"value"}';

		my $comp_result = False;
		given %i{'cmp'} {
			when '>' 	{ $comp_result = %registers{%i{'reg'}} > %i{'value'} }
			when '<' 	{ $comp_result = %registers{%i{'reg'}} < %i{'value'} }
			when '==' 	{ $comp_result = %registers{%i{'reg'}} == %i{'value'} }
			when '!=' 	{ $comp_result = %registers{%i{'reg'}} != %i{'value'} }
			when '<=' 	{ $comp_result = %registers{%i{'reg'}} <= %i{'value'} }
			when '>=' 	{ $comp_result = %registers{%i{'reg'}} >= %i{'value'} }
		}
		
		if $comp_result {
			my $result = %registers{%i{'target'}};
			given %i{'op'} {
				when 'inc'	{ $result += %i{'change'} }
				when 'dec'	{ $result -= %i{'change'} }
			}
			%registers{%i{'target'}} = $result;
			$highest = $result if $result > $highest;
		}
	}

	return (%registers.values.max, $highest);
}

sub parseInstruction($line) {
	$line ~~ / (\w+) \s (\w+) \s (\-?\d+) \s if \s (\w+) \s (<[< > = !]>+) \s (\-?\d+) /;
	my %instr = ('target' => $0, 'op' => $1, 'change' => $2+0, 'reg' => $3, 'cmp' => $4, 'value' => $5+0);
	%instr;
}