// binary_adder.sv
//
// Perform binary addition on two 2-bit signals to produce a 3-bit output.
//
// switches sw[1:0] are the first two-bit binary input
// switches sw[3:2] are the second two-bit binary input


module binary_adder (
        input logic [3:0] sw,   // First four switches for input
        output logic [2:0] led  // First three LEDs for output
    );
    logic [1:0] carry; // Carry of the two inputs

    // Bit 0 sum (led) and carry
    xor(led[0], sw[0], sw[2]);              // led[0] = sw[0] xor sw[2]
    and(carry[0], sw[0], sw[2]);            // carry[0] = sw[0] and sw[2]
    // Bit 1 sum and carry
    xor(led[1], sw[1], sw[3], carry[0]);    // led[1] = sw[1] xor sw[3] xor carry[0]
    and(co1, sw[1], sw[3]);                 // carry[1] = sw[1] and sw[3]
    and(co2, sw[1], carry[0]);              // carry[1] = sw[1] and sw[3]
    and(co3, sw[3], carry[0]);              // carry[1] = sw[1] and sw[3]
    or(carry[1], co1, co2, co3);            // carry[1] = co1 or co2 or co3
    // Bit 2 sum
    buf(led[2], carry[1]);                  // led[2] = carry[1]

endmodule
