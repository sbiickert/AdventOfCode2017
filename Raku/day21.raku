#!/usr/bin/env raku

use lib $*PROGRAM.dirname ~ '/lib';
use AOC::Util;
use AOC::Geometry;
use AOC::Grid;

my $INPUT_PATH = '../input';
# my $INPUT_FILE = 'day21_test.txt';
my $INPUT_FILE = 'day21_challenge.txt';
my @input = read_input("$INPUT_PATH/$INPUT_FILE");

say "Advent of Code 2017, Day 21: Fractal Art";

my %rules = build_rules(@input);

my @start_matrix = (".#.","..#","###");
my $grid = Grid.new(default => '.', rule => AdjacencyRule::ROOK);
$grid.load(@start_matrix);

# $grid.print;
# say $grid.get(Extent.from_ints(0,0,1,1));
# say $grid.get(Extent.from_ints(1,1,2,2));

my $pt1 = solve_part($grid, 5);
say "Part One: the number of pixels on after 5 iterations is $pt1";

my $pt2 = solve_part($grid, 18);
say "Part Two: the number of pixels on after 18 iterations is $pt2";

exit( 0 );

sub solve_part(Grid $start_grid, Int $iterations) {
	my $grid = $start_grid.clone;
	for 1..$iterations -> $i {
		say $i;
		my $work = Grid.new(default => '.', rule => AdjacencyRule::ROOK);

		my $size = $grid.extent.width %% 2 ?? 2 !! 3;
		my $out_size = $size + 1;

		loop (my $x = 0, my $out_x = 0; $x < $grid.extent.max.x; $x += $size, $out_x += $out_size) {
			loop (my $y = 0, my $out_y = 0; $y < $grid.extent.max.y; $y += $size, $out_y += $out_size) {
				my $source = Extent.from_ints($x,$y,$x+$size-1,$y+$size-1);
				# say $source;
				my $target = Extent.from_ints($out_x, $out_y, $out_x+$out_size-1, $out_y+$out_size-1);
				# say $target;

				my @in_matrix = $grid.get($source);
				my $in_str = str_from_matrix(@in_matrix);
				# say $in_str;
				my @out_matrix = %rules{$in_str}.flat;
				# say @out_matrix.raku;
				$work.set($target, @out_matrix);
			}
		}

		$grid = $work;
		# $grid.print;
	}

	my %hist = $grid.histogram;
	return %hist{'#'};
}


sub build_rules(@input) {
	my %rules;
	for @input -> $line {
		my ($str1, $str2) = $line.split(" => ");
		my @matrix2 = matrix_from_str($str2);
		%rules{$str1} = @matrix2;

		my @matrix1 = matrix_from_str($str1);
		my @flipped = flip_matrix(@matrix1);
		my $str_flipped = str_from_matrix(@flipped);
		%rules{$str_flipped} = @matrix2;

		for 1..3 {
			@matrix1 = rotate_matrix(@matrix1);
			my $str_rotated = str_from_matrix(@matrix1);
			%rules{$str_rotated} = @matrix2;
			@flipped = flip_matrix(@matrix1);
			$str_flipped = str_from_matrix(@flipped);
			%rules{$str_flipped} = @matrix2;
		}
	}

	# say %rules.raku;
	# die;
	%rules;
}

sub matrix_from_str($str) {
	my @m;
	# say "in: $str";
	my @rows = $str.split("/");
	for @rows.kv -> $r, $row {
		my @chars = $row.split('', :skip-empty);
		@m[$r] = @chars;
	}
	# say "out: " ~ @m.raku;
	@m;
}

sub str_from_matrix(@matrix) {
	# say "in: " ~ @matrix.raku;

	my $str = @matrix.map( -> @row {@row.join('')}).join('/');
	
	# say "out: $str";
	$str;
}

sub rotate_matrix(@matrix) {
	# say "rotate in: " ~ @matrix.raku;
	my @rotated = ();
	for 0..@matrix.end { @rotated.push( [] ) }

	while @matrix.elems > 0 {
		my @row = @matrix.pop.flat;
		for @row.kv -> $i, $pix {
			@rotated[$i].push($pix);
		}
	}
	# say "out: " ~ @rotated.raku;
	@rotated;
}

sub flip_matrix(@matrix) {
	# say "flip in: " ~ @matrix.raku;
	my @flipped = @matrix.map(-> @row { @row.reverse.List });
	# say "out: " ~ @flipped.raku;
	@flipped;
}