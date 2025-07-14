//////////////////////////////////////////////////////////////////////////
/// Name: Nithish Reddy KVS
/// Module-Name: mux2
//////////////////////////////////////////////////////////////////////////

module mux2(operand_1, operand_2, select, result);

    parameter SIZE = 32;

    // input port
    input [SIZE-1:0] operand_1, operand_2;                                     // Input operands (32 bits each)
    input select;                                                              // Select signal

    // output port
    output [SIZE-1:0] result;                                                  // Output (32 bits)

    // Assign the output based on the select signal
    assign result = select ? operand_2 : operand_1;

endmodule