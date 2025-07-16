unit module AOC::Geometry3D;

class Coord3D {...}

class Coord3D is export {
	has Int $.x = 0;
	has Int $.y = 0;
	has Int $.z = 0;
	
	# class method: origin
	method origin(::?CLASS:U $c2d:) {
		$c2d.new(x => 0, y => 0, z => 0);
	}

    # class method: construct from three Ints
	method from_ints(::?CLASS:U $c2d: Int $x, Int $y, Int $z) {
		$c2d.new( x => $x, y => $y, z => $z );
	}
	
	method Str { "[$.x,$.y,$.z]" }
	
	multi method gist(Coord3D:U:) { self.^name }
	multi method gist(Coord3D:D:) { "•[$.x, $.y, $.z]" }
	
	multi infix:<eqv>(Coord3D $l, Coord3D $r) { $l.x == $r.x && $l.y == $r.y && $l.z == $r.z }
	
	method add(Coord3D $other --> Coord3D) {
		Coord3D.new( x => $.x + $other.x, y => $.y + $other.y, z => $.z + $other.z )
	}

	method addTo(Coord3D $other) {
		$!x += $other.x;
		$!y += $other.y;
		$!z += $other.z;
	}
	
	method delta(Coord3D $other --> Coord3D) {
		Coord3D.new( x => $other.x - $.x, y => $other.y - $.y, z => $other.z - $.z )
	}
	
	method manhattanDistanceTo(Coord3D $other --> Int) {
		return abs($other.x - $.x) + abs($other.y - $.y) + abs($other.z - $.z);
	}

}