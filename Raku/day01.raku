#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
#use AOC::Geometry;
#use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day01_test.txt';
my $INPUT_FILE = 'day01_challenge.txt';
my $input = read_grouped_input("$INPUT_PATH/$INPUT_FILE")[0][0];

say "Advent of Code 2024, Day 1: Inverse Captcha";

$input.split("", :skip-empty)
    ==> map( -> $x {$x+0})
    ==> my @numbers;

solve_part_one(@numbers);
#solve_part_two(@input);

exit( 0 );

sub solve_part_one(@numbers) {
    @numbers.push(@numbers[0]); # Repeat the first digit as the last
    my $result = 0;
	for @numbers.kv -> $index, $value {
        if $index < @numbers.elems -1 {
            $result += $value if @numbers[$index+1] == $value;
        }
    }
    say "Part One: the captcha is $result";
}

sub solve_part_two(@input) {
	
}
