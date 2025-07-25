unit module AOC::Geometry;

class Coord {...}
class Position {...}
class Extent {...}

my %OFFSET_DIRS = ('N' 	=> Coord.new(x => 0, y => -1),
					'NE' 	=> Coord.new(x => 1, y =>-1),
					'E' 	=> Coord.new(x => 1, y => 0),
					'SE' 	=> Coord.new(x => 1, y => 1),
					'S' 	=> Coord.new(x => 0, y => 1),
					'SW' 	=> Coord.new(x =>-1, y => 1),
					'W' 	=> Coord.new(x =>-1, y => 0),
					'NW' 	=> Coord.new(x =>-1, y =>-1));
					
					
my %OFFSET_ALIASES = ('UP'	=> 'N', 'RIGHT' => 'E', 'DOWN' 	=> 'S', 'LEFT' 	=> 'W',
						'U' => 'N', 'R' => 'E', 'D' => 'S', 'L' => 'W',
						'^' => 'N', '>' => 'E', 'v' => 'S', '<' => 'W');

sub resolve_offset_alias(Str $dir --> Str) {
	if %OFFSET_DIRS{$dir}:exists {
		return $dir;
	}
	return %OFFSET_ALIASES{$dir} // Nil;
}

my %ROTATION_DIRS = ('CW' => 1, 'CCW' => -1);

my %ROTATION_ALIASES = ('R' => 'CW', 'RIGHT' => 'CW',
						'L' => 'CCW', 'LEFT' => 'CCW');

sub resolve_rotation_alias(Str $dir --> Str) {
	if %ROTATION_DIRS{$dir}:exists {
		return $dir;
	}
	return %ROTATION_ALIASES{$dir} // Nil;
}

enum AdjacencyRule is export <ROOK BISHOP QUEEN>;
# constant ROOK is export = 'ROOK';
# constant BISHOP is export = 'BISHOP';
# constant QUEEN is export = 'QUEEN';

my %ADJACENCY_RULES = (ROOK    => ['N','E','S','W'],
						BISHOP => ['NE','SE','SW','NW'],
						QUEEN  => ['N','NE','E','SE','S','SW','W','NW']);

sub adjacent_dirs(AdjacencyRule $rule --> Array) is export {
	my @arr = %ADJACENCY_RULES{$rule}.flat;
	return @arr;
}


class Coord is export {
	has Int $.x = 0;
	has Int $.y = 0;
	
	# class method: origin
	method origin(::?CLASS:U $c2d:) {
		$c2d.new(x => 0, y => 0);
	}
	
	# class method: get the Coord that represents a directional offset
	method get_offset(::?CLASS:U $c2d: Str $direction --> Coord) {
		my $off = resolve_offset_alias($direction);
		if $off {
			return %OFFSET_DIRS{$off};
		}
		return Coord.origin;
	}
	
	# class method: construct from two Ints
	method from_ints(::?CLASS:U $c2d: Int $x, Int $y) {
		$c2d.new( x => $x, y => $y );
	}
	
	# class method: construct from a Str representation 
	method from_str(::?CLASS:U $c2d: $str) {
		my $x = 0; my $y = 0;
		if $str ~~ rx:s/\[(\d+)\, ?(\d+)\]/ {
			$x = +~$0; $y = +~$1;
		}
		$c2d.new( x => $x, y => $y );
	}
	
	method Str { "[$.x,$.y]" }
	
	multi method gist(Coord:U:) { self.^name }
	multi method gist(Coord:D:) { "•[$.x, $.y]" }
	
	multi infix:<eqv>(Coord $l, Coord $r) { $l.x == $r.x && $l.y == $r.y }
	#multi infix:<+>(Coord $l, Coord $r) { $l.add($r) } <-- not working

	method col returns Int { $.x; }
	method row returns Int { $.y; }
	
	method add(Coord $other --> Coord) {
		Coord.new( x => $.x + $other.x, y => $.y + $other.y )
	}
	
	method is_adjacent(Coord $other, AdjacencyRule $rule = AdjacencyRule::ROOK --> Bool) {
		given $rule {
			when AdjacencyRule::ROOK {
				return self.manhattanDistanceTo($other) == 1;
			}
			when AdjacencyRule::BISHOP {
				return abs($!x - $other.x) == 1 &&
						abs($!y - $other.y) == 1;
			}
			when AdjacencyRule::QUEEN {
				return (self.manhattanDistanceTo($other) == 1) ||
					(abs($!x - $other.x) == 1 &&
					abs($!y - $other.y) == 1)
			}
		}
	}
	
	
	method get_adjacent_coords(AdjacencyRule $rule = AdjacencyRule::ROOK) {
		my @result = ();
		if (%ADJACENCY_RULES{$rule}:exists) {
			my @dirs = %ADJACENCY_RULES{$rule}.flat;
			for @dirs -> $dir {
				@result.push(self.offset($dir));
			}
		}
		return @result;
	}

	method offset(Str $dir, Int $size = 1 --> Coord) {
		return self.clone if $size == 0;
		my $resolved_dir = resolve_offset_alias($dir);
		my $off = Coord.get_offset($resolved_dir);
		if (abs($size) != 1) {
			$off = Coord.from_ints($off.x * $size, $off.y * $size);
		}
		return self.add($off);
	}
	
	method delta(Coord $other --> Coord) {
		Coord.new( x => $other.x - $.x, y => $other.y - $.y )
	}
	
	method distanceTo(Coord $other --> Num) {
		my $delta = $.delta($other);
		return sqrt($delta.x**2 + $delta.y**2);
	}
	
	method manhattanDistanceTo(Coord $other --> Int) {
		return abs($other.x - $.x) + abs($other.y - $.y);
	}
}

class Position is export {
	has Coord $.coord;
	has Str $.dir;
	
	# Overriding default constructor to check $dir
	method new( Coord :$coord, Str :$dir ) {
		my $resolved = resolve_offset_alias($dir // 'N') // 'N';
		return self.bless(coord => $coord, dir => $resolved);
	}
	
	method Str { '{' ~ $.coord.Str ~ ' ' ~ $.dir ~ '}' }
	
	multi method gist(Coord:U:) { self.^name }
	multi method gist(Coord:D:) { self.Str }
	
	multi infix:<eqv>(Position $l, Position $r) {
		$l.coord eqv $r.coord && $l.dir eq $r.dir;
	}
	
	method turn(Str $rotation_direction --> Position) {
		my $rot_dir = resolve_rotation_alias($rotation_direction);
		my $step = 0;
		if $rot_dir { $step = %ROTATION_DIRS{$rot_dir}; }
		my @ordered = %ADJACENCY_RULES{AdjacencyRule::ROOK}.flat; # ('N', 'E', 'S', 'W');
		my $index = @ordered.first($.dir, :k);
		$index = ($index + $step) % 4;
		return Position.new(coord => $.coord.clone, dir => @ordered[$index]);
	}

	method turn_fast(Int $amt) {
		# turn is better (more flexible calling, does not mutate) but this is twice as fast
		# -1 is CCW, 1 is CW
		if $!dir eq 'N' 	{ $!dir = $amt < 0 ?? 'W' !! 'E' }
		elsif $!dir eq 'E' 	{ $!dir = $amt < 0 ?? 'N' !! 'S' }
		elsif $!dir eq 'S' 	{ $!dir = $amt < 0 ?? 'E' !! 'W' }
		else 				{ $!dir = $amt < 0 ?? 'S' !! 'N' }
	}
	
	method move_forward(Int $distance = 1 --> Position) {
		my $off = %OFFSET_DIRS{$.dir};
		my $move = Coord.new(x => $off.x * $distance,
							 y => $off.y * $distance);
		#my $new_coord = self.coord + $move;
		my $new_coord = self.coord.add($move);
		return Position.new(coord => $new_coord, dir => self.dir);
	}
}

class Segment is export {
	has Coord $.from;
	has Coord $.to;
	
	method Str { $.from ~ "->" ~ $.to }
	
	multi method gist(Segment:U:) { self.^name }
	multi method gist(Segment:D:) { self.Str }
	
	multi infix:<eqv>(Segment $l, Segment $r) {
		$l.from eqv $r.from && $l.to eqv $r.to;
	}
	
	method is_horizontal(--> Bool) {
		$.from.y == $.to.y;
	}
	
	method is_vertical(--> Bool) {
		$.from.x == $.to.x;
	}
	
	method direction(--> Str) {
		if $.is_horizontal {
			return $.from.x < $.to.x ?? 'E' !! 'W';
		}
		elsif $.is_vertical {
			return $.from.y < $.to.y ?? 'S' !!'N';
		}
		
		if ($.from.x < $.to.x) {
			return $.from.y < $.to.y ?? 'SE' !! 'NE';
		}
		return $.from.y < $.to.y ?? 'SW' !! 'NW';
	}
}


class Extent1D is export {
	has Range $.range;

	submethod TWEAK {
		if $!range.min > $!range.max {
			$!range = $!range.max..$!range.min;
		}
	}

	method min(--> Int) { return $.range.min; }
	method max(--> Int) { return $.range.max; }

	method Str { '{min: ' ~ self.min ~ ' max: ' ~ self.max ~ '}' }
	
	multi infix:<eqv>(Extent1D $l, Extent1D $r) { $l.range eqv $r.range; }

	method size(--> Int) { return $.range.minmax[1] - $.range.minmax[0] + 1; }

	multi method contains(Extent1D $other --> Bool) {
		return self.min <= $other.min && $other.max <= self.max;
	}

	multi method contains(Int $value --> Bool) {
		return self.min <= $value && $value <= self.max;
	}

	method overlaps(Extent1D $other --> Bool) {
		return !(self.intersect($other) ~~ Nil);
	}

	method union(Extent1D $other --> Extent1D) {
		return Extent1D.new(range => min(self.min, $other.min)..max(self.max, $other.max));
	}

	method intersect(Extent1D $other --> Extent1D) {
		my $bigmin = max(self.min, $other.min);
		my $smallmax = min(self.max, $other.max);
		if ($bigmin <= $smallmax) {
			return Extent1D.new(range => $bigmin..$smallmax);
		}
		return Nil;
	}
}


class Extent is export {
	has Coord $.min;
	has Coord $.max;
	
	# class method: construct from Ints 
	method from_ints(::?CLASS:U $e2d: Int $xmin, Int $ymin, Int $xmax, Int $ymax) {
		my $min = Coord.new( x => $xmin, y => $ymin );
		my $max = Coord.new( x => $xmax, y => $ymax );
		$e2d.from_coords( my Coord @ =[$min, $max] );
	}
	
	# class method: construct from a list of Coord 
	method from_coords(::?CLASS:U $e2d: Coord @coords) {
		my $ext = Extent.new;
		
		for @coords -> $coord {
			if $coord.isa(Coord) {
				$ext = $ext.expand_to_fit($coord);
			}
		}
		return $ext;
	}
	
	method expand_to_fit( Coord $coord --> Extent ) {
		my Coord $new_min;
		my Coord $new_max;
		
		if $.is_empty {
			$new_min = $coord.clone;
			$new_max = $coord.clone;
		}
		else {
			$new_min = Coord.new( x => min($.min.x, $coord.x), y => min($.min.y, $coord.y) );
			$new_max = Coord.new( x => max($.max.x, $coord.x), y => max($.max.y, $coord.y) );
		}
		
		return Extent.new( min => $new_min, max => $new_max )
	}
	
	method is_empty(--> Bool) {
		return !$.min && !$.max;
	}
	
	method Str { $.is_empty ?? '[EMPTY]' !! "[$.min,$.max]" }
	
	multi method gist(Extent:U:) { self.^name }
	multi method gist(Extent:D:) { $.is_empty ?? "▭[EMPTY]" !! "▭[$.min, $.max]" }
	
	multi infix:<eqv>(Extent $l, Extent $r) { $l.min eqv $r.min && $l.max eqv $r.max }
	
	method nw(--> Coord) { return $.min.clone; }
	method ne(--> Coord) { return Coord.new( x => $.max.x, y => $.min.y ); }
	method sw(--> Coord) { return Coord.new( x => $.min.x, y => $.max.y ); }
	method se(--> Coord) { return $.max.clone; }

	method corners( --> Array) { [self.nw, self.ne, self.sw, self.se] }
	
	method width(--> Int) {
		return $.is_empty ?? 0 !! $.max.x - $.min.x + 1;
	}
	
	method height(--> Int) {
		return $.is_empty ?? 0 !! $.max.y - $.min.y + 1;
	}
	
	method area(--> Int) {
		return $.width * $.height;
	}

	method x_range(--> Range) {
		$.min.x..$.max.x
	}

	method y_range(--> Range) {
		$.min.y..$.max.y
	}
	
	method all_coords(--> Array of Coord) {
		my Coord @coords = ();
		
		for $.min.x .. $.max.x X $.min.y .. $.max.y -> $pair {
			@coords.push( Coord.new( x => $pair[0], y => $pair[1] ) );
		}
		return @coords;
	}
	
	multi method contains( Coord $coord --> Bool ) {
		if $.is_empty { return False }
		return ($.min.x <= $coord.x && $coord.x <= $.max.x)
			&& ($.min.y <= $coord.y && $coord.y <= $.max.y);
	}

	multi method contains( Extent $box --> Bool ) {
		self.contains($box.nw) && self.contains($box.ne) &&
			self.contains($box.sw) && self.contains($box.se)
	}
	
	# intersect
	method intersect( Extent $other --> Extent ) {
		if self.is_empty || $other.is_empty { return Extent.new; } # empty Extent
		my $common_min_x = max($.min.x, $other.nw.x);
		my $common_max_x = min($.max.x, $other.se.x);
		if ($common_max_x < $common_min_x) { return Extent.new; } # empty Extent
		my $common_min_y = max($.min.y, $other.nw.y);
		my $common_max_y = min($.max.y, $other.se.y);
		if ($common_max_y < $common_min_y) { return Extent.new; } # empty Extent

		return Extent.from_ints($common_min_x, $common_min_y, $common_max_x, $common_max_y);
	}
	
	# union 
	method union( Extent $other --> Array of Extent ) {
		my Extent @results = ();
		if self.is_empty || $other.is_empty { return @results; }
		#say "union of " ~ self.Str ~ " and " ~ $other.Str;
		if self eqv $other { return self.clone; }

		my Extent $e_int = self.intersect($other);
		if $e_int.is_empty {
			#say "no valid intersection. Returning clones of self and other";
			@results.push( self.clone, $other.clone );
			return @results;
		}
		#say "the intersection is " . $e_int.to_str;

		@results.push($e_int);
		for ( self, $other ) -> $e {
			if $e eqv $e_int { next; }

			if ($e.nw.x < $e_int.nw.x) { # xmin
				if ($e.nw.y < $e_int.nw.y) { # ymin
					@results.push( Extent.from_ints($e.nw.x, $e.nw.y, $e_int.nw.x-1, $e_int.nw.y-1) );
				}
				if ($e.se.y > $e_int.se.y) { # ymax
					@results.push( Extent.from_ints($e.nw.x, $e_int.se.y+1, $e_int.nw.x-1, $e.se.y) );
				}
				@results.push( Extent.from_ints($e.nw.x, $e_int.nw.y, $e_int.nw.x-1, $e_int.se.y) );
			}
			if ($e_int.se.x < $e.se.x) {
				if ($e.nw.y < $e_int.nw.y) { # ymin
					@results.push( Extent.from_ints($e_int.se.x+1, $e.nw.y, $e.se.x, $e_int.nw.y-1) );
				}
				if ($e.se.y > $e_int.se.y) { # ymax
					@results.push( Extent.from_ints($e_int.se.x+1, $e_int.se.y+1, $e.se.x, $e.se.y) );
				}
				@results.push( Extent.from_ints($e_int.se.x+1, $e_int.nw.y, $e.se.x, $e_int.se.y) );
			}
			if ($e.nw.y < $e_int.nw.y) { #ymin
				@results.push( Extent.from_ints($e_int.nw.x, $e.nw.y, $e_int.se.x, $e_int.nw.y-1) );
			}
			if ($e_int.se.y < $e.se.y) { #ymax
				@results.push( Extent.from_ints($e_int.nw.x, $e_int.se.y+1, $e_int.se.x, $e.se.y) );
			}
		}
		return @results;
	}
	
	method inset( Int $inset --> Extent ) {
		if $.is_empty { return Extent.new; }
		return Extent.from_ints( $.min.x + $inset, $.min.y + $inset,
								 $.max.x - $inset, $.max.y - $inset );
	}
}

