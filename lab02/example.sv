// example.sv


module example(
        input logic [3:0] sw,   // First four switches for input
        output logic [3:0] led  // First four LEDs for output
    );

    // led[0] output: 'and' operation of SW[0], SW[1], SW[2], SW[3]
    and(led[0],sw[0],sw[1]),sw[2],sw[3]);
    // led[1] output: 'or' operation of SW[0], SW[1], SW[2], SW[3]
    or(led[1],sw[0],sw[1]),sw[2],sw[3]);
    // led[2] output: 'nand' operation of SW[0], SW[1], SW[2], SW[3]
    not(led[2],led[0]);
    // led[3] output: 'nor' operation of SW[0], SW[1], SW[2], SW[3]
    not(led[3],led[1]);

endmodule
