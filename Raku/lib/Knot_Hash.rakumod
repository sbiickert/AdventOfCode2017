unit module Knot_Hash;

multi mk_sparse_knot_hash(Int @input, Int $cycles = 1) is export {
	my Int @sparse_hash = [0..255];
	my $position = 0;
	my $skip_size = 0;
    for 1..$cycles {
    	($position,$skip_size) = knot_hash(@sparse_hash, @input, $position, $skip_size);
    }
    @sparse_hash;
}

multi mk_sparse_knot_hash(Str $input, Int $cycles = 1) is export {
    $input.split("", :skip-empty) ==> map( -> $c { ord($c) }) ==> my Int @lengths;
    @lengths.push(|[17, 31, 73, 47, 23]);
    mk_sparse_knot_hash(@lengths, $cycles);
}

sub mk_dense_knot_hash(Str $input, Int $cycles = 1) is export {
    my @sparse_hash = mk_sparse_knot_hash($input, $cycles);
    get_dense_hash(@sparse_hash);
}

sub mk_hex_knot_hash(Str $input, Int $cycles = 1) is export {
    mk_dense_knot_hash($input, $cycles)
    ==> map( -> $n { sprintf "%02x", $n })
	==> join("");
}

sub knot_hash(Int @numbers, Int @lengths, Int $start_pos, Int $start_skip_size) is export {
    my $pos = $start_pos;
    my $skip_size = $start_skip_size;
    for @lengths -> $length {
        my Int $end = $pos + $length - 1;
        reverse_numbers(@numbers, $pos, $end);
        $pos = ($pos + $length + $skip_size) % @numbers.elems;
        $skip_size++;
    }
    ($pos, $skip_size);
}

sub reverse_numbers(@numbers, Int $start, Int $end) {
    my @numbers_to_reverse = @numbers[$start..min(@numbers.end, $end)];
    my $overrun = 0;
    if $end > @numbers.end {
        $overrun = $end - @numbers.end;
        @numbers_to_reverse.push(|@numbers[0..$end % @numbers.elems]);
    }

    my @reversed_numbers = @numbers_to_reverse.reverse;

    my @splice1 = @reversed_numbers[0..@reversed_numbers.end-$overrun];
    @numbers.splice($start, @splice1.elems, @splice1);
    if $overrun > 0 {
        my @overrun_splice = @reversed_numbers[*-$overrun..*];
        @numbers.splice(0, @overrun_splice.elems, @overrun_splice);
    }
}

sub get_dense_hash(@sparse_hash) is export {
    @sparse_hash.batch(16)
        ==> map( -> $block {$block.reduce(&infix:<+^>)}); # Bitwise XOR
}
