unit module AOC::Grid;

use AOC::Geometry;

role GridGlyph is export {
	method glyph( --> Str) { ... }
}

enum GridDataMode is export <HASH ARRAY>;

class Grid is export {
	has %!h_data = Hash.new;
	has @!a_data = Array.new;
	has $.data_mode = GridDataMode::HASH;
	has $.default = '.';
	has AOC::Geometry::AdjacencyRule $.rule is required is rw;
	has Extent $.extent is rw;
	has Int $.initial_size = 0;
	
	submethod TWEAK() {
		%!h_data = Hash.new;
		$!extent = Extent.new;
		@!a_data = Array.new();
		if $!initial_size > 0 && $!data_mode == GridDataMode::ARRAY {
			@!a_data = [$!default xx $!initial_size] xx $!initial_size;
			$!extent = Extent.from_ints(0,0,$!initial_size-1,$!initial_size-1);
		}
	}
	
	multi method get(Str $key --> Any) {
		given $!data_mode {
			when GridDataMode::HASH {
				if %!h_data{$key}:exists {
					return %!h_data{$key};
				}
			}
			when GridDataMode::ARRAY {
				say "get by string key not supported in GridDataMode::ARRAY"; die;
			}
		}
		return $.default;
	}
	
	multi method get(Coord $coord --> Any) {
		given $!data_mode {
			when GridDataMode::HASH {
				return self.get($coord.Str);
			}
			when GridDataMode::ARRAY {
				return self.get($coord.x, $coord.y);
			}
		}
		return $.default;
	}

	multi method get(Int $x, Int $y --> Any) {
		given $!data_mode {
			when GridDataMode::HASH {
				return self.get(Coord.new(x => $x, y => $y));
			}
			when GridDataMode::ARRAY {
				if @!a_data[$y][$x].defined {
					return @!a_data[$y][$x];
				}
			}
		}
		return $.default;
	}

	multi method get(Extent $box --> Array) {
		my @result = ();
		for $box.min.y..$box.max.y -> $y {
			my @row = ();
			for $box.min.x..$box.max.x -> $x {
				my $value = self.get($x, $y);
				@row.push($value);
			}
			@result.push(@row);
		}
		@result;
	}
	
	multi method get_glyph(Str $key --> Str) {
		my $value = self.get($key);
		return self!glyph_from_value($value);
	}
	
	multi method get_glyph(Coord $coord --> Str) {
		my $value = self.get($coord);
		return self!glyph_from_value($value);
	}

	multi method get_glyph(Int $x, Int $y --> Any) {
		my $value = self.get($x, $y);
		return self!glyph_from_value($value);
	}
	
	method !glyph_from_value(Any $value --> Str) {
		if $value.isa(List) {
			return $value[0].Str;
		}
		elsif $value.isa(Map) {
			return $value{'glyph'}.Str;
		}
		elsif $value.does(GridGlyph) {
			return $value.glyph;
		}
		return $value.Str;
	}

	multi method set(Int $x, Int $y, Any $value) {
		given $!data_mode {
			when GridDataMode::HASH {
				my $coord = Coord.new(x => $x, y => $y);
				self.set($coord, $value);
			}
			when GridDataMode::ARRAY {
				if $x < 0 || $y < 0 { die "Negative x or y passed to DenseGrid::set" }
				@!a_data[$y][$x] = $value;

				# Update the extent to include the x, y
				if $.extent.is_empty || $x < $.extent.min.x || $.extent.max.x < $x || $y < $.extent.min.y || $.extent.max.y < $y {
					my $key = Coord.new(x => $x, y => $y);
					my $temp = $.extent.expand_to_fit($key);
					$.extent = $temp;
				}
			}
		}
	}

	multi method set(Coord $key, Any $value) {
		given $!data_mode {
			when GridDataMode::HASH {
				%!h_data{$key.Str} = $value;
				
				# Update the extent to include the $coord
				if ! $.extent.contains($key) {
					my $temp = $.extent.expand_to_fit($key);
					$.extent = $temp;
				}
			}
			when GridDataMode::ARRAY {
				self.set($key.x, $key.y, $value);
			}
		}
	}

	multi method set(Extent $box, @values) {
		for @values.kv -> $r, @row {
			for @row.kv -> $c, $value {
				self.set($c+$box.min.x, $r+$box.min.y, $value);
			}
		}
	}
	
	method set_rule(AdjacencyRule $r) {
		self.rule = $r;
	}

	multi method clear(Int $x, Int $y, Bool :$reset_extent = False) {
		given $!data_mode {
			when GridDataMode::HASH {
				my $coord = Coord.new( x => $x, y => $y );
				self.clear($coord, reset_extent => $reset_extent);
			}
			when GridDataMode::ARRAY {
				@!a_data[$y][$x]:delete;
				self.reset_extent if $reset_extent;
			}
		}
	}
	
	multi method clear(Coord $coord, Bool :$reset_extent = False) {
		given $!data_mode {
			when GridDataMode::HASH {
				%!h_data{$coord.Str}:delete;
				self.reset_extent if $reset_extent;
			}
			when GridDataMode::ARRAY {
				self.clear($coord.x, $coord.y, reset_extent => $reset_extent);
			}
		}
	}
	
	method reset_extent() {
		given $!data_mode {
			when GridDataMode::HASH {
				$.extent = Extent.from_coords( self.coords );
			}
			when GridDataMode::ARRAY {
				my $x = 0; my $y = 0;
				for @!a_data.kv -> $r,$row {
					if $row ~~ Positional {
						$y = $r if $row.elems > 0;
						$x = max($x,$row.end);
					}
				}
				$.extent = Extent.from_ints(0,0,$x,$y);
			}
		}
	}
	
	method coords(Str $with_value = '') {
		my Coord @result = ();
		given $!data_mode {
			when GridDataMode::HASH {
				for %!h_data.keys -> $key {
					if $with_value.chars == 0 || self.get_glyph($key) eq $with_value {
						@result.push(Coord.from_str($key));
					}
				}
			}
			when GridDataMode::ARRAY {
				for $.extent.all_coords -> $key {
					my $value = self.get_glyph($key);
					if $value eq $.default { next }
					if $with_value.chars == 0 || $value eq $with_value {
						@result.push($key);
					}
				}
			}
		}
		return @result;
	}
	
	method histogram(Bool $include_unset = False --> Hash) {
		my Int %hist is default(0);
		
		my Coord @coords_to_summarize = ();
		if ($include_unset) {
			@coords_to_summarize = self.extent.all_coords;
		}
		else {
			@coords_to_summarize = self.coords;
		}
		
		for @coords_to_summarize -> $c {
			my $val = self.get_glyph($c);
			%hist{$val} = %hist{$val} + 1;
		}
		
		return %hist;
	}
	
	method neighbors(Coord $c --> Array) {
		return $c.get_adjacent_coords($.rule);
	}

	method flood_fill(Coord $c, $value --> Bool) {
		my $limit = self.extent;
		my $touched_infinity = False;
		my $target_value = self.get($c);
		my $to_fill = SetHash.new: $c;
		while $to_fill.elems > 0 {
			my $next_to_fill = SetHash.new;
			for $to_fill.keys -> $coord {
				self.set($coord, $value);
				my @n = self.neighbors($coord).grep( -> $c {
					$to_fill !(cont) $c && self.get($c) eq $target_value });
				for @n -> $c {
					if $limit.contains($c) {
						$next_to_fill.set($c);
					}
					else { $touched_infinity = True }
				}
			}
			$to_fill = $next_to_fill;
		}
		$touched_infinity
	}
	
	method print(:%markers = {}, Bool :$invert_y = False) {
		print self.sprint(markers => %markers, invert_y => $invert_y);
	}
	
	method sprint(:%markers = {}, Bool :$invert_y = False --> Str) {
		my $str = '';
		return $str if $.extent.is_empty;
		
		my $xmin = $.extent.min.x;
		my $xmax = $.extent.max.x;
		my $ymin = $.extent.min.y;
		my $ymax = $.extent.max.y;
		
		my @y_indexes = ();
		for ($ymin..$ymax) -> $y {
			@y_indexes.push($y);
		}
		@y_indexes = @y_indexes.reverse if $invert_y;

		for @y_indexes -> $y {
			my @row = ();
			for ($xmin..$xmax) -> $x {
				my $c_str = Coord.from_ints($x, $y).Str;
				my $glyph = self.get_glyph($x, $y);
				if %markers.keys.elems > 0 && (%markers{$c_str}:exists) {
					$glyph = %markers{$c_str};
				}
				@row.push($glyph);
			}
			@row.push("\n");
			$str ~= @row.join(' ');
		}
		
		return $str;
	}
	
	method load(@rows) {
		for 0..@rows.end -> $r {
			my @cols = @rows[$r].split('', :skip-empty);
			for 0..@cols.end -> $c {
				given $!data_mode {
					when GridDataMode::HASH {
						if @cols[$c] ne $.default {
							self.set(Coord.from_ints($c, $r), @cols[$c]);
						}
					}
					when GridDataMode::ARRAY {
						self.set($c, $r, @cols[$c]);
					}
				}
			}
		}
	}
}

# class DenseGrid is Grid is export {
# 	has @!a_data = Array.new;
# 	has Int $.initial_size = 0;

# 	submethod TWEAK {
# 		@!a_data = Array.new();
# 		if $!initial_size > 0 {
# 			@!a_data = [$!default xx $!initial_size] xx $!initial_size;
# 			$!extent = Extent.from_ints(0,0,$!initial_size,$!initial_size);
# 		}
# 	}

# 	multi method get(Str $key --> Any) {
# 		say "get by string key not supported in DenseGrid"; die;
# 		return $.default;
# 	}
	
# 	multi method get(Coord $key --> Any) {
# 		self.get($key.x, $key.y);
# 	}

# 	multi method get(Int $x, Int $y --> Any) {
# 		if @!a_data[$y][$x].defined {
# 			return @!a_data[$y][$x];
# 		}
# 		return $.default;
# 	}

# 	multi method get(Extent $box --> Array) {
# 		my @result = ();
# 		for $box.min.y..$box.max.y -> $y {
# 			my @row = ();
# 			for $box.min.x..$box.max.x -> $x {
# 				my $value = self.get($x, $y);
# 				@row.push($value);
# 			}
# 			@result.push(@row);
# 		}
# 		@result;
# 	}

# 	multi method set(Int $x, Int $y, Any $value) {
# 		if $x < 0 || $y < 0 { die "Negative x or y passed to DenseGrid::set" }
# 		@!a_data[$y][$x] = $value;
		
# 		# Update the extent to include the x, y
# 		if $.extent.is_empty || $x < $.extent.min.x || $.extent.max.x < $x || $y < $.extent.min.y || $.extent.max.y < $y {
# 			my $key = Coord.new(x => $x, y => $y);
# 			my $temp = $.extent.expand_to_fit($key);
# 			$.extent = $temp;
# 		}
# 	}
	
# 	multi method set(Coord $key, Any $value) {
# 		self.set($key.x, $key.y, $value);
# 	}

# 	multi method set(Extent $box, @values) {
# 		for @values.kv -> $r, @row {
# 			for @row.kv -> $c, $value {
# 				self.set($c, $r, $value);
# 			}
# 		}
# 	}
	
# 	multi method clear(Int $x, Int $y, Bool :$reset_extent = False) {
# 		@!a_data[$y][$x]:delete;
# 		self.reset_extent if $reset_extent;
# 	}
	
# 	multi method clear(Coord $key, Bool :$reset_extent = False) {
# 		self.clear($key.x, $key.y, reset_extent => $reset_extent);
# 	}
	
# 	method coords(Str $with_value = '') {
# 		my Coord @result = ();
# 		for $.extent.all_coords -> $key {
# 			if $with_value.chars == 0 || self.get_glyph($key) eq $with_value {
# 				@result.push($key);
# 			}
# 		}
# 		return @result;
# 	}
	
# 	method load(@rows) {
# 		for 0..@rows.end -> $r {
# 			my @cols = @rows[$r].split('', :skip-empty);
# 			for 0..@cols.end -> $c {
# 				self.set($c, $r, @cols[$c]);
# 			}
# 		}
# 	}

# }