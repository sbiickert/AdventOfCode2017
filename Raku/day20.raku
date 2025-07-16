#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry3D;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day20_test.txt';
my $INPUT_FILE = 'day20_challenge.txt';
my @input = read_grouped_input("$INPUT_PATH/$INPUT_FILE", 0);

say "Advent of Code 2017, Day 20: Particle Swarm";

class Particle {...}

my @particles = @input.kv.map( -> $i, $line { Particle.from_str($i, $line) } );

my $pt1 = solve_part_one(@particles);
say "Part One: $pt1";

my $pt2 = solve_part_two(@particles);
say "Part Two: $pt2";

exit( 0 );

sub solve_part_one(@particles) {
	my $origin = Coord3D.origin;
	my @sorted = @particles;
	my $is_stable = False;
	my $prev_top_10 = "";

	my $i = 0;
	while !$is_stable {
		for @sorted -> $particle {
			$particle.update;
		}
		@sorted = @sorted.sort: {$^a.p.manhattanDistanceTo($origin) <=> $^b.p.manhattanDistanceTo($origin)};

		if $i %% 100 {
			my $top_10 = @sorted[0..10].map( -> $p { $p.id }).join(',');
			$is_stable = $top_10 eq $prev_top_10;
			$prev_top_10 = $top_10;
			# say "$i $top_10";
		}
		$i++;
	}

	return @sorted.head.id;
}

sub solve_part_two(@particles) {
	return 2;
}

class Particle {
	has Int $.id;
	has Coord3D $.p;
	has Coord3D $.v;
	has Coord3D $.a;

    # class method: construct from three Ints
	method from_str(::?CLASS:U $par: Int $id, Str $def) {
		my @parts = $def.split(", ");
		@parts[0] ~~ / (\-?\d+) \, (\-?\d+) \, (\-?\d+) /;
		my $p = Coord3D.new(x => $/[0]+0, y => $/[1]+0, z => $/[2]+0);
		@parts[1] ~~ / (\-?\d+) \, (\-?\d+) \, (\-?\d+) /;
		my $v = Coord3D.new(x => $/[0]+0, y => $/[1]+0, z => $/[2]+0);
		@parts[2] ~~ / (\-?\d+) \, (\-?\d+) \, (\-?\d+) /;
		my $a = Coord3D.new(x => $/[0]+0, y => $/[1]+0, z => $/[2]+0);
		$par.new(id => $id, p => $p, v => $v, a => $a);
	}

	method update() {
		$!v = $!v.add($!a);
		$!p = $!p.add($!v);
	}
}