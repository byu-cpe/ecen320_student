// binary_adder.sv
//
// Perform binary addition on two 4-bit signals to produce a 5-bit output.
//
// switches sw[3:0] are the first two-bit binary input
// switches sw[8:0] are the second two-bit binary input


module binary_adder (
        input logic [7:0] sw,   // First four switches for input
        output logic [8:0] led  // First three LEDs for output
    );
    logic [7:0] carry;          // Carry of the two inputs
    logic [7:0] carry_gen;      // Carry generate
    logic [7:0] carry_prop;     // Carry propagate
    logic [7:0] carry_in_prop;  // Carry in propagate

    // Bit 0 sum (led) and carry
    xor(led[0], sw[0], sw[4]);              // sum[0]
    and(carry_gen[0], sw[0], sw[4]);        // carry_gen[0]
    or(carry_prop[0], sw[0], sw[4]);        // carry_prop[0]
    and(carry_in_prop[0], carry_prop[0], 1'b0); // No carry in for bit 0
    or(carry[0], carry_gen[0], carry_in_prop[0]);
    // Bit 1 sum (led) and carry
    xor(led[1], sw[1], sw[5]);              // sum[1]
    and(carry_gen[1], sw[1], sw[5]);        // carry_gen[1]
    or(carry_prop[1], sw[1], sw[5]);        // carry_prop[1]
    and(carry_in_prop[1], carry_prop[1], carry[0]);
    or(carry[1], carry_gen[1], carry_in_prop[1]);
    // Bit 2 sum (led) and carry
    xor(led[2], sw[2], sw[6]);              // sum[2]
    and(carry_gen[2], sw[2], sw[6]);        // carry_gen[2]
    or(carry_prop[2], sw[2], sw[6]);        // carry_prop[2]
    and(carry_in_prop[2], carry_prop[2], carry[1]);
    or(carry[2], carry_gen[2], carry_in_prop[2]);
    // Bit 3 sum (led) and carry
    xor(led[3], sw[3], sw[7]);              // sum[3]
    and(carry_gen[3], sw[3], sw[7]);        // carry_gen[3]
    or(carry_prop[3], sw[3], sw[7]);        // carry_prop[3]
    and(carry_in_prop[3], carry_prop[3], carry[2]);
    or(carry[3], carry_gen[3], carry_in_prop[3]);

    // Bit 2 sum
    buf(led[5], carry[3]);                  

endmodule
